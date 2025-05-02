<template>
  <div class="vmdContainer">
    <el-card
      v-loading="loading"
      :element-loading-text="trans('editorLoading')"
      shadow="never"
    >
      <div
        ref="editor"
        class="editor"
        :style="{ minHeight: this.height + 'px' }"
      ></div>
    </el-card>
    <upload-attachment
      type="image"
      ref="imageRef"
      :limit="10"
      @confirm="imageSelected"
    />
  </div>
</template>

<script>
import Vditor from "vditor";
import { t } from "@/lang";
import "vditor/dist/index.css";
import SparkMD5 from "spark-md5";
export default {
  data() {
    return {
      trans: t,
      vdtr: null,
      loading: true,

      attachMap: {},
      attachIds: [],
    };
  },
  name: "MarkdownEditorFormItem",
  emits: ["update:modelValue"],
  props: {
    modelValue: {
      type: String,
      default: () => {
        return "";
      },
    },
    extraPostData: {
      type: Object,
      default: () => ({
        getData() {
          return {};
        },
        valid() {
          return true;
        },
      }),
    },
    height: {
      type: Number,
      default: () => 600,
    },
  },
  computed: {
    content: {
      get() {
        return this.modelValue;
      },
      set(value) {
        this.$emit("update:modelValue", value);
      },
    },
  },
  components: {},
  beforeUnmount() {
    this.vdtr?.destroy();
    this.vdtr = null;
  },
  mounted() {
    const that = this;
    const editor = new Vditor(this.$refs.editor, {
      height: this.height,
      mode: "sv",
      toolbar: [
        "headings",
        "bold",
        "italic",
        "strike",
        "link",
        "|",
        "list",
        "ordered-list",
        "check",
        "outdent",
        "indent",
        "|",
        "quote",
        "line",
        "code",
        "inline-code",
        "insert-before",
        "insert-after",
        "|",
        "record",
        "table",
        "|",
        "undo",
        "redo",
        "|",
        "fullscreen",
        "edit-mode",
        {
          name: "insertImage",
          tipPosition: "s",
          tip: "插入图片",
          className: "right",
          icon: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 43 43">
              <g fill="none">
                  <path fill="currentColor" d="M44 24a2 2 0 1 0-4 0h4ZM24 8a2 2 0 1 0 0-4v4Zm15 32H9v4h30v-4ZM8 39V9H4v30h4Zm32-15v15h4V24h-4ZM9 8h15V4H9v4Zm0 32a1 1 0 0 1-1-1H4a5 5 0 0 0 5 5v-4Zm30 4a5 5 0 0 0 5-5h-4a1 1 0 0 1-1 1v4ZM8 9a1 1 0 0 1 1-1V4a5 5 0 0 0-5 5h4Z"/>
                  <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="4" d="m6 35l10.693-9.802a2 2 0 0 1 2.653-.044L32 36m-4-5l4.773-4.773a2 2 0 0 1 2.615-.186L42 31m-5-13V6m-5 5l5-5l5 5"/>
              </g>
          </svg>`,
          click() {
            console.debug(that.$refs?.imageRef);
            if (that.$refs?.imageRef) {
              that.$refs.imageRef.showDialog = true;
            }
          },
        },
        {
          name: "more",
          toolbar: [
            "both",
            "code-theme",
            "content-theme",
            "export",
            "outline",
            "preview",
            "devtools",
            "info",
            "help",
          ],
        },
      ],
      toolbarConfig: {
        pin: true,
      },
      cache: {
        enable: false,
      },
      after: () => {
        this.vdtr?.setValue(this.content);
        console.debug("load content:", this.content);
        this.editorInit = true;
        this.loading = false;
      },
      input: (data) => {
        // console.debug("MarkdownEditorFormItem: content change:", data);
        that.onContentChange(data);
      },
    });

    this.vdtr = editor;
  },
  methods: {
    async vdtrBeforeUpload(files) {
      const valid = this.extraPostData.valid();
      console.log("vdtrBeforeUpload:", this.extraPostData);
      if (valid !== true) {
        showErrorMsg(valid);
        return [];
      }

      this.vdtr.vditor.options.upload.extraData = this.extraPostData.getData();

      if (files.length > 15) {
        showErrorMsg(t("picNumLimit"));
        return [];
      }
      let result = [];
      for (const file of files) {
        const hash = await this.getFileHash(file);
        // console.log("file hash:", file, hash);
        try {
          const rsp = await uploadCheckHashApi({
            filename: file.name,
            hash: hash,
          });
          // console.log("uploadCheckHashApi rsp:", rsp);
          if (rsp?.data?.has && rsp?.data?.url && rsp?.data?.id) {
            showInfoMsg(t("picExists"));
            this.vdtr.insertValue(
              `![${file.name}](${encodeURI(rsp.data.url)})`
            );
            this.attachIds.push(rsp.data.id);
            continue;
          }

          result.push(file);
        } catch (err) {
          showErrorMsg(t("picHashCheckErr") + `: ${err}`);
          continue;
        }
      }

      // console.log("file to upload:", this.attachIds, result);
      return result;
    },
    vdtrHandleErr(msg) {
      showErrorMsg(msg);
    },
    vdtrFormatRsp(editor, msg) {
      if (msg) {
        const rsp = JSON.parse(msg);

        if (!rsp) {
          showErrorMsg(t("picUploadErr") + `: ${msg}`);
          return "";
        }

        if (!rsp?.data || !Array.isArray(rsp.data)) {
          showErrorMsg(t("picUploadErr") + `: ${msg}`);
          return "";
        }

        let result = {
          msg: "ok",
          code: 0,
          data: {
            errFiles: [],
            succMap: {},
          },
        };
        const uploads = rsp.data;
        for (const upload of uploads) {
          result["data"]["succMap"][upload.filename] = upload.url;
          this.attachIds.push(upload.id);
        }

        return JSON.stringify(result);
      }
      showErrorMsg(t("invalidRsp"));
      return "";
    },
    async getFileHash(file) {
      const content = await file.arrayBuffer();
      // console.log("file arrayBuffer length:", content.byteLength);
      const spark = new SparkMD5.ArrayBuffer();
      spark.append(content);
      return spark.end();
    },
    readContent() {
      const content = this.vdtr.getValue();

      return content;
    },
    loadContent(content = "") {
      if (content === "") {
        content = this.content;
      }
      if (this.editorInit) {
        console.debug("manual load content:", content);
        this.vdtr?.setValue(content);
      }
    },
    onContentChange(data) {
      this.$emit("update:modelValue", data);
    },
    imageSelected(data) {
      const urlPrefix = `${window.location.protocol}//${window.location.host}/`;
      data.forEach((item) => {
        this.vdtr?.insertValue(`![](${urlPrefix}${item.url})\n`);
      });
    },
  },
};
</script>
<style scoped lang="scss">
.vmdContainer {
  display: flex;
  flex-direction: column;
  .editor {
    margin-top: 12px;
  }
}
</style>
