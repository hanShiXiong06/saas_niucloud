CREATE TABLE IF NOT EXISTS `{{prefix}}ai_msg`  (
`id` int(13) NOT NULL AUTO_INCREMENT COMMENT '',
`site_id` int(13) NOT NULL COMMENT '站点id',
`msg_id` varchar(50) COMMENT '对话ID',
`role` varchar(255) COMMENT '名称',
`content` longtext COMMENT '内容',
`is_new` int(1) DEFAULT '1' COMMENT '新会话',
`token` int(10) COMMENT '消耗token',
`status` int(1) COMMENT '状态',
`create_time` int(13) COMMENT '创建时间',
PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 220 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代码生成表字段信息表' ROW_FORMAT = Dynamic;
INSERT INTO `{{prefix}}ai_msg` VALUES ('930','100000','ujYRQQWzuH','user','你能做什么','1',NULL,NULL,'1712552080');
INSERT INTO `{{prefix}}ai_msg` VALUES ('931','100000','ujYRQQWzuH','system','我不太确定你的问题是什么。如果你能提供更多上下文，我会尽力回答你的问题。如果你需要帮助，我可以提供一些建议和指导。','1','0',NULL,'1712552083');
INSERT INTO `{{prefix}}ai_msg` VALUES ('932','100000','ujYRQQWzuH','user','你是谁','0',NULL,NULL,'1712552089');
INSERT INTO `{{prefix}}ai_msg` VALUES ('933','100000','ujYRQQWzuH','system','您好，我是科大讯飞研发的认知智能大模型，我的名字叫讯飞星火认知大模型。我可以和人类进行自然交流，解答问题，高效完成各领域认知智能需求。','1','0',NULL,'1712552092');
INSERT INTO `{{prefix}}ai_msg` VALUES ('934','100000','ujYRQQWzuH','user','高原洋芋','0',NULL,NULL,'1712552103');
INSERT INTO `{{prefix}}ai_msg` VALUES ('935','100000','ujYRQQWzuH','system','标题：高原上的味蕾奇迹——洋芋的自白

🌄 朋友们，你们知道吗？在遥远的高原上，有一种被风雕雨刻的坚韧食材，它就是我——高原洋芋。今天，就让我带你们领略一下我的生活和为什么我会是那么多人心中的“美味宠儿”。

🌱 我生长在海拔数千米的高原，那里的土壤纯净，空气清新，阳光充足。虽然气候多变，温差大，但我就是喜欢这样的挑战。因为只有这样，我才能长出紧实的肉质，储存足够的营养，成为那个独一无二的“高原小强”。

🥔 有人说，我是自然界的馈赠，是高原的灵魂。我不仅能做成各种美食——无论是炖、煮、烤、炸，都能散发出让人垂涎的香气。而且我富含膳食纤维、维生素C和B6，还有丰富的钾和抗氧化剂，是健康饮食的好伙伴。

🏔️ 在高原上，人们的生活离不开我。清晨，牧民们用我熬制一锅香浓的洋芋汤，为新的一天注入活力；傍晚，篝火旁，一家人围坐一起，享受着烤洋芋带来的温暖和满足。

🧣 而我最自豪的时刻，是在每年的洋芋节上。那时，人们会用我制作成百上千种美食，从洋芋饼到洋芋泥，从洋芋条到洋芋派，每一口都蕴含着高原的味道和人们的爱。

🌟 所以，亲爱的朋友们，下次你们在品尝到我的时候，不妨想象一下那片蓝天下，金黄土地上，我是如何坚韧地生长，如何被精心培育，最终成为你们餐桌上的美味。

🌈 最后，我想说，虽然我只是一颗小小的洋芋，但我承载着高原的骄傲，带着土地的祝福，希望能在你的生活中留下一丝不同的风味。

#高原洋芋# #自然的馈赠# #健康食材# #洋芋的自白#

💌 分享给你们，希望你们能爱上这个来自高原的朋友——我，高原洋芋。记得尝一尝哦！🌱🌼🥔','1','0',NULL,'1712552129');
INSERT INTO `{{prefix}}ai_msg` VALUES ('937','100000','uAy3qS1Y67','user','你是谁','1',NULL,NULL,'1713089693');
INSERT INTO `{{prefix}}ai_msg` VALUES ('938','100000','uAy3qS1Y67','system','您好，我是科大讯飞研发的认知智能大模型，我的名字叫讯飞星火认知大模型。我可以和人类进行自然交流，解答问题，高效完成各领域认知智能需求。','1','0',NULL,'1713089696');
INSERT INTO `{{prefix}}ai_msg` VALUES ('939','100000','ueu2yrvEXA','user','你是谁','1',NULL,NULL,'1713090243');
INSERT INTO `{{prefix}}ai_msg` VALUES ('940','100000','ueu2yrvEXA','system','您好，我是科大讯飞研发的认知智能大模型，我的名字叫讯飞星火认知大模型。我可以和人类进行自然交流，解答问题，高效完成各领域认知智能需求。','1','0',NULL,'1713090246');
INSERT INTO `{{prefix}}ai_msg` VALUES ('941','100000','ueu2yrvEXA','user','$data=$shareModel->([site_id=>$this->site_id,mid=>$mid])->findOrEmpty();增加查询条件查询当天数据，时间字段create_time','0',NULL,NULL,'1713098672');
INSERT INTO `{{prefix}}ai_msg` VALUES ('942','100000','ueu2yrvEXA','system','要增加查询条件以查询当天数据，可以在`findOrEmpty()`方法中添加`where`子句。首先，需要获取当前日期的开始和结束时间，然后在`where`子句中使用`between`方法来筛选出当天的数据。

解析后的代码如下：

```php
$todayStart = mktime(0, 0, 0, date(\'m\'), date(\'d\'), date(\'Y\'));
$todayEnd = mktime(23, 59, 59, date(\'m\'), date(\'d\'), date(\'Y\'));

$data = $shareModel->where([
    \'site_id\' => $this->site_id,
    \'mid\' => $mid,
    \'create_time\' => [\'between\', [$todayStart, $todayEnd]]
])->findOrEmpty();
```

这段代码首先获取了当天的开始和结束时间戳，然后在`where`子句中添加了一个条件，要求`create_time`字段的值在当天的开始和结束时间之间。最后，使用`findOrEmpty()`方法查询满足条件的记录。','1','0',NULL,'1713098684');
INSERT INTO `{{prefix}}ai_msg` VALUES ('943','100000','ueu2yrvEXA','user','Array to string conversion下面代码报错$todayStart = mktime(0, 0, 0, date(m), date(d), date(Y));
$todayEnd = mktime(23, 59, 59, date(m), date(d), date(Y));

$data = $shareModel->([
    site_id => $this->site_id,
    mid => $mid,
    create_time => [between, [$todayStart, $todayEnd]]
])->findOrEmpty();','0',NULL,NULL,'1713100159');
INSERT INTO `{{prefix}}ai_msg` VALUES ('944','100000','ueu2yrvEXA','system','这段代码中的错误可能是由于在调用`date()`函数时，没有使用正确的参数。`date()`函数需要三个参数：时间戳、格式化字符串和默认值。请尝试将代码修改为以下内容：

```php
$todayStart = mktime(0, 0, 0, date(\'m\'), date(\'d\'), date(\'Y\'));
$todayEnd = mktime(23, 59, 59, date(\'m\'), date(\'d\'), date(\'Y\'));

$data = $shareModel->([
    \'site_id\' => $this->site_id,
    \'mid\' => $mid,
    \'create_time\' => [between, [$todayStart, $todayEnd]]
])->findOrEmpty();
```

这里，我将`date(m)`、`date(d)`和`date(Y)`分别替换为`date(\'m\')`、`date(\'d\')`和`date(\'Y\')`。','1','0',NULL,'1713100171');
INSERT INTO `{{prefix}}ai_msg` VALUES ('945','100000','ueu2yrvEXA','user','element plus的表格在表格后面合计知道列的数据','0',NULL,NULL,'1713106999');
INSERT INTO `{{prefix}}ai_msg` VALUES ('946','100000','ueu2yrvEXA','system','要在 Element Plus 的表格后面显示列的数据合计，可以使用以下方法：

1. 首先，确保你已经安装了 Element Plus 并在项目中引入了相关组件。如果还没有安装，可以使用以下命令安装：

```bash
npm install element-plus --save
```

2. 在你的 Vue 项目中引入 Element Plus 的表格组件（`el-table`）和相关的样式：

```javascript
import { ElTable, ElTableColumn } from \'element-plus\';
import \'element-plus/lib/theme-chalk/index.css\';
```

3. 在你的 Vue 组件中使用 `el-table` 组件，并添加一个用于显示合计数据的新列。在这个新列中，你可以使用 `el-table-column` 的 `footer-template` 属性来自定义合计数据的显示方式。例如，你可以使用一个简单的计算函数来计算每一列的总和：

```html
<template>
  <el-table :data=\"tableData\" border>
    <el-table-column prop=\"name\" label=\"姓名\" width=\"180\"></el-table-column>
    <el-table-column prop=\"age\" label=\"年龄\" width=\"180\"></el-table-column>
    <el-table-column prop=\"score\" label=\"分数\" width=\"180\">
      <template #footer>
        <span>{{ totalScore }}</span>
      </template>
    </el-table-column>
  </el-table>
</template>

<script>
export default {
  data() {
    return {
      tableData: [
        { name: \'张三\', age: 18, score: 90 },
        { name: \'李四\', age: 20, score: 85 },
        { name: \'王五\', age: 22, score: 88 },
      ],
      totalScore: 0,
    };
  },
  mounted() {
    this.calculateTotalScore();
  },
  methods: {
    calculateTotalScore() {
      this.totalScore = this.tableData.reduce((sum, item) => sum + item.score, 0);
    },
  },
};
</script>
```

在这个例子中，我们创建了一个包含姓名、年龄和分数的表格。我们为分数列添加了一个合计行，并使用 `calculateTotalScore` 方法计算总分。当表格数据发生变化时，你需要重新调用 `calculateTotalScore` 方法来更新合计数据。','1','0',NULL,'1713107039');
INSERT INTO `{{prefix}}ai_msg` VALUES ('947','100000','ueu2yrvEXA','user','<template>
  <div class=\"main-container\">
    <el-card class=\"box-card !border-none\" shadow=\"never\">
      <div class=\"flex justify-between items-center\">
        <span class=\"text-page-title\">{{ pageName }}</span>
      </div>

      <el-card
        class=\"box-card !border-none my-[10px] -search-wrap\"
        shadow=\"never\"
      >
        <el-form
          :inline=\"true\"
          :model=\"order.searchParam\"
          ref=\"searchFormRef\"
        >
          <el-form-item :label=\"t(orderNo)\" prop=\"order_no\">
            <el-input
              v-model=\"order.searchParam.order_no\"
              :placeholder=\"t(orderNoPlaceholder)\"
            />
          </el-form-item>
          <el-form-item :label=\"t(orderStatus)\" prop=\"order_status\">
            <el-
              v-model=\"order.searchParam.order_status\"
              clearable
              class=\"input-width\"
            >
              <el-option :label=\"t(Placeholder)\" value=\"\" />
              <el-option
                :label=\"item.name\"
                :value=\"key\"
                v-for=\"(item, key) in orderStatus\"
                :key=\"key\"
              />
            </el->
          </el-form-item>
          <el-form-item label=\"出票状态\" prop=\"is_ticking\">
            <el-
              v-model=\"order.searchParam.is_ticking\"
              clearable
              class=\"input-width\"
            >
              <el-option label=\"全部\" value=\"\" />
              <el-option label=\"未出票\" value=\"0\" />
              <el-option label=\"已出票\" value=\"1\" />
            </el->
          </el-form-item>
          <!-- <el-form-item :label=\"t(createTime)\" prop=\"create_time\">
            <el-date-picker v-model=\"order.searchParam.create_time\" type=\"datetimerange\"
              value-format=\"YYYY-MM-DD HH:mm:ss\" :start-placeholder=\"t(startDate)\" :end-placeholder=\"t(endDate)\" />
          </el-form-item> -->
          <el-form-item label=\"使用时间\" prop=\"create_time\">
            <el-date-picker
              v-model=\"order.searchParam.start_time\"
              type=\"datetimerange\"
              value-format=\"YYYY-MM-DD\"
              :start-placeholder=\"t(startDate)\"
              :end-placeholder=\"t(endDate)\"
            />
          </el-form-item>
          <el-form-item :label=\"t(payTime)\" prop=\"pay_time\">
            <el-date-picker
              v-model=\"order.searchParam.pay_time\"
              type=\"datetimerange\"
              value-format=\"YYYY-MM-DD HH:mm:ss\"
              :start-placeholder=\"t(startDate)\"
              :end-placeholder=\"t(endDate)\"
            />
          </el-form-item>
          <el-form-item>
            <el-button type=\"primary\" @click=\"loadOrderList()\">{{
              t(\"search\")
            }}</el-button>
            <el-button @click=\"resetForm(searchFormRef)\">{{
              t(\"reset\")
            }}</el-button>
          </el-form-item>
        </el-form>
      </el-card>

      <div class=\"mt-[10px]\">
        <el-
          @ion-change=\"handleionChange\"
          :data=\"order.data\"
          size=\"large\"
          v-loading=\"order.loading\"
          show-summary=\"true\"
          sum-text=\"合计\"
        >
          <template #empty>
            <span>{{ !order.loading ? t(\"emptyData\") : \"\" }}</span>
          </template>
          <el--column type=\"ion\" width=\"55\" />
          <el--column
            prop=\"order_no\"
            :label=\"t(orderNo)\"
            align=\"left\"
            min-width=\"200\"
          />
          <el--column
            :label=\"t(scenicInfo)\"
            align=\"left\"
            min-width=\"200\"
          >
            <template #default=\"{ row }\">
              <div class=\"flex items-center cursor-pointer\">
                <div
                  class=\"min-w-[60px] h-[60px] flex items-center justify-center mr-[10px]\"
                >
                  <img
                    class=\"max-w-[60px] max-h-[60px]\"
                    v-if=\"row.image_thumb_small\"
                    :src=\"img(row.image_thumb_small)\"
                    alt=\"\"
                  />
                  <img class=\"max-w-[60px] max-h-[60px]\" v-else src=\"\" alt=\"\" />
                </div>
                <div class=\"flex flex flex-col\">
                  <a
                    href=\"javascript:;\"
                    :title=\"row.scenic.scenic_name\"
                    class=\"multi-hidden\"
                    >{{ row.scenic.scenic_name }}</a
                  >
                  <span>{{ row.goods_name || \"\" }}</span>
                </div>
              </div>
            </template>
          </el--column>
          <el--column
            :label=\"t(orderMoney)\"
            min-width=\"180\"
            align=\"center\"
          >
            <template #default=\"{ row }\">
              {{ row.order_money }}
            </template>
          </el--column>
          <el--column
            label=\"数量\"
            prop=\"num\"
            min-width=\"180\"
            align=\"center\"
          >
            <!-- <template #default=\"{ row }\">
              {{ row.order_money }}
            </template> -->
          </el--column>
          <el--column
            prop=\"order_from_name\"
            :label=\"t(orderSource)\"
            align=\"center\"
            min-width=\"200\"
          />
          <el--column
            :show-overflow-tooltip=\"true\"
            :label=\"t(memberInfo)\"
            align=\"left\"
            min-width=\"200\"
          >
            <template #default=\"{ row }\">
              <div
                class=\"flex items-center cursor-pointer\"
                @click=\"toMember(row.member.member_id)\"
                v-if=\"row.member\"
              >
                <img
                  class=\"w-[50px] h-[50px] mr-[10px]\"
                  v-if=\"row.member.headimg\"
                  :src=\"img(row.member.headimg)\"
                  alt=\"\"
                />
                <img
                  class=\"w-[50px] h-[50px] mr-[10px]\"
                  v-else
                  src=\"@/app/assets/images/default_headimg.png\"
                  alt=\"\"
                />
                <div class=\"flex flex flex-col\">
                  <a
                    href=\"javascript:;\"
                    :title=\"row.member.nickname\"
                    class=\"multi-hidden\"
                    >{{ row.member.nickname }}</a
                  >
                  <span>{{ row.member.mobile || \"\" }}</span>
                </div>
              </div>
            </template>
          </el--column>

          <el--column label=\"使用时间\" min-width=\"180\" align=\"center\">
            <template #default=\"{ row }\">
              {{ row.start_time || \"\" }}
            </template>
          </el--column>
          <el--column
            :label=\"t(orderStatus)\"
            min-width=\"180\"
            align=\"center\"
          >
            <template #default=\"{ row }\">
              <div class=\"flex items-center\">
                {{ row.order_status_info.name }}
                <div v-if=\"row.order_status == 1\">
                  <el-tag class=\"ml-2\" type=\"info\" v-if=\"row.is_ticking == 1\"
                    >已出票</el-tag
                  >
                  <el-button
                    class=\"ml-2\"
                    v-if=\"row.is_ticking != 1\"
                    type=\"primary\"
                    plain
                    size=\"small\"
                    @click=\"editOrder(row.order_id)\"
                    >立即出票</el-button
                  >
                </div>
              </div>
            </template>
          </el--column>
          <el--column
            :label=\"t(operation)\"
            align=\"right\"
            fixed=\"right\"
            width=\"130\"
          >
            <template #default=\"{ row }\">
              <!-- <el-button class=\"ml-2\" v-if=\"row.is_ticking == 1\" type=\"primary\" link size=\"small\"
                @click=\"editOrder(row.order_id)\">重新出票</el-button> -->
              <el-button type=\"primary\" link @click=\"infoEvent(row)\">{{
                t(\"info\")
              }}</el-button>
            </template>
          </el--column>
        </el->
        <div class=\"mt-[16px] flex justify-between\">
          <el-button @click=\"Event()\">选中出票</el-button>
          <el-pagination
            v-model:current-page=\"order.page\"
            v-model:page-size=\"order.limit\"
            layout=\"total, sizes, prev, pager, next, jumper\"
            :total=\"order.total\"
            @size-change=\"loadOrderList()\"
            @current-change=\"loadOrderList\"
          />
        </div>
      </div>

      <!-- <order-edit ref=\"editOrderDialog\" @complete=\"loadOrderList\" /> -->
    </el-card>
  </div>
</template>


import { reactive, ref } from \"vue\";
import { t } from \"@/lang\";
import {
  getScenicOrderList,
  getScenicOrderStatus,
  changeIsTick,
  Ticket,
} from \"@/addon/tourism_tick/api/tourism\";
import { img } from \"@/utils/common\";
import { useRouter, useRoute } from \"vue-router\";
import { AnyObject } from \"@/types/global\";
import { ElMessageBox, FormInstance } from \"element-plus\";
// 选中数据
const Data = ref<any[]>([]);
const handleionChange = (val) => {
  Data.value = val.map((item) => item.order_id);
};
const Event = async () => {
  if (Data.value.length > 0) {
    Ticket(Data.value).then((res) => {
      loadOrderList();
    });
  } else {
    ElMessageBox.confirm(\"请先选择要出票的数据\", t(\"warning\"), {
      confirmButtonText: t(\"confirm\"),
      cancelButtonText: t(\"cancel\"),
      type: \"warning\",
    });
  }
};
const route = useRoute();
const router = useRouter();
const pageName = route.meta.title;

interface OrderType {
  page: number;
  limit: number;
  total: number;
  loading: boolean;
  data: AnyObject[];
  searchParam: {
    order_no: string;
    order_status: string;
    create_time: any[];
    start_time: any[];
    pay_time: any[];
    is_ticking?: string | number;
    status?: string | number;
  };
}
const order = reactive<OrderType>({
  page: 1,
  limit: 10,
  total: 0,
  loading: true,
  data: [],
  searchParam: {
    order_no: \"\",
    order_status: \"\",
    create_time: [],
    pay_time: [],
  },
});

const searchFormRef = ref<FormInstance>();
const editOrder = async (e) => {
  await changeIsTick(e);
  loadOrderList();
};
*
 * 获取订单列表
 */
const loadOrderList = (page: number = 1) => {
  order.loading = true;
  order.page = page;

  getScenicOrderList({
    page: order.page,
    limit: order.limit,
    ...order.searchParam,
  })
    .then((res) => {
      order.loading = false;
      order.data = res.data.data;
      order.total = res.data.total;
    })
    .catch(() => {
      order.loading = false;
    });
};
loadOrderList();

// 获取订单状态
interface OrderStatusType {
  name: string;
}
const orderStatus = ref<OrderStatusType[]>([]);
const checkOrderStatus = () => {
  getScenicOrderStatus().then((res) => {
    orderStatus.value = res.data;
  });
};
checkOrderStatus();

const infoEvent = (info: AnyObject) => {
  const routeData = router.resolve({
    path: \"/orderticking/orderticking_edit\",
    query: { order_id: info.order_id },
  });

  window.open(routeData.href, \"_blank\");
};

// 重置
const resetForm = (formEl: FormInstance | undefined) => {
  if (!formEl) return;
  formEl.resetFields();
  loadOrderList();
};



只需要合并num这一列','0',NULL,NULL,'1713107171');
INSERT INTO `{{prefix}}ai_msg` VALUES ('948','100000','ueu2yrvEXA','system','```vue
<el--column
            prop=\"num\"
            min-width=\"180\"
            align=\"center\"
          />
```','1','0',NULL,'1713107176');
INSERT INTO `{{prefix}}ai_msg` VALUES ('949','100000','u0z3maHCxv','user','<template>
  <div class=\"main-container\">
    <el-card class=\"box-card !border-none\" shadow=\"never\">
      <div class=\"flex justify-between items-center\">
        <span class=\"text-page-title\">{{ pageName }}</span>
      </div>

      <el-card
        class=\"box-card !border-none my-[10px] -search-wrap\"
        shadow=\"never\"
      >
        <el-form
          :inline=\"true\"
          :model=\"order.searchParam\"
          ref=\"searchFormRef\"
        >
          <el-form-item :label=\"t(orderNo)\" prop=\"order_no\">
            <el-input
              v-model=\"order.searchParam.order_no\"
              :placeholder=\"t(orderNoPlaceholder)\"
            />
          </el-form-item>
          <el-form-item :label=\"t(orderStatus)\" prop=\"order_status\">
            <el-
              v-model=\"order.searchParam.order_status\"
              clearable
              class=\"input-width\"
            >
              <el-option :label=\"t(Placeholder)\" value=\"\" />
              <el-option
                :label=\"item.name\"
                :value=\"key\"
                v-for=\"(item, key) in orderStatus\"
                :key=\"key\"
              />
            </el->
          </el-form-item>
          <el-form-item label=\"出票状态\" prop=\"is_ticking\">
            <el-
              v-model=\"order.searchParam.is_ticking\"
              clearable
              class=\"input-width\"
            >
              <el-option label=\"全部\" value=\"\" />
              <el-option label=\"未出票\" value=\"0\" />
              <el-option label=\"已出票\" value=\"1\" />
            </el->
          </el-form-item>
          <!-- <el-form-item :label=\"t(createTime)\" prop=\"create_time\">
            <el-date-picker v-model=\"order.searchParam.create_time\" type=\"datetimerange\"
              value-format=\"YYYY-MM-DD HH:mm:ss\" :start-placeholder=\"t(startDate)\" :end-placeholder=\"t(endDate)\" />
          </el-form-item> -->
          <el-form-item label=\"使用时间\" prop=\"create_time\">
            <el-date-picker
              v-model=\"order.searchParam.start_time\"
              type=\"datetimerange\"
              value-format=\"YYYY-MM-DD\"
              :start-placeholder=\"t(startDate)\"
              :end-placeholder=\"t(endDate)\"
            />
          </el-form-item>
          <el-form-item :label=\"t(payTime)\" prop=\"pay_time\">
            <el-date-picker
              v-model=\"order.searchParam.pay_time\"
              type=\"datetimerange\"
              value-format=\"YYYY-MM-DD HH:mm:ss\"
              :start-placeholder=\"t(startDate)\"
              :end-placeholder=\"t(endDate)\"
            />
          </el-form-item>
          <el-form-item>
            <el-button type=\"primary\" @click=\"loadOrderList()\">{{
              t(\"search\")
            }}</el-button>
            <el-button @click=\"resetForm(searchFormRef)\">{{
              t(\"reset\")
            }}</el-button>
          </el-form-item>
        </el-form>
      </el-card>

      <div class=\"mt-[10px]\">
        <el-
          @ion-change=\"handleionChange\"
          :data=\"order.data\"
          size=\"large\"
          v-loading=\"order.loading\"
          show-summary=\"true\"
          sum-text=\"合计\"
        >
          <template #empty>
            <span>{{ !order.loading ? t(\"emptyData\") : \"\" }}</span>
          </template>
          <el--column type=\"ion\" width=\"55\" />
          <el--column
            prop=\"order_no\"
            :label=\"t(orderNo)\"
            align=\"left\"
            min-width=\"200\"
          />
          <el--column
            :label=\"t(scenicInfo)\"
            align=\"left\"
            min-width=\"200\"
          >
            <template #default=\"{ row }\">
              <div class=\"flex items-center cursor-pointer\">
                <div
                  class=\"min-w-[60px] h-[60px] flex items-center justify-center mr-[10px]\"
                >
                  <img
                    class=\"max-w-[60px] max-h-[60px]\"
                    v-if=\"row.image_thumb_small\"
                    :src=\"img(row.image_thumb_small)\"
                    alt=\"\"
                  />
                  <img class=\"max-w-[60px] max-h-[60px]\" v-else src=\"\" alt=\"\" />
                </div>
                <div class=\"flex flex flex-col\">
                  <a
                    href=\"javascript:;\"
                    :title=\"row.scenic.scenic_name\"
                    class=\"multi-hidden\"
                    >{{ row.scenic.scenic_name }}</a
                  >
                  <span>{{ row.goods_name || \"\" }}</span>
                </div>
              </div>
            </template>
          </el--column>
          <el--column
            :label=\"t(orderMoney)\"
            min-width=\"180\"
            align=\"center\"
          >
            <template #default=\"{ row }\">
              {{ row.order_money }}
            </template>
          </el--column>
          <el--column
            label=\"数量\"
            prop=\"num\"
            min-width=\"180\"
            align=\"center\"
          >
            <!-- <template #default=\"{ row }\">
              {{ row.order_money }}
            </template> -->
          </el--column>
          <el--column
            prop=\"order_from_name\"
            :label=\"t(orderSource)\"
            align=\"center\"
            min-width=\"200\"
          />
          <el--column
            :show-overflow-tooltip=\"true\"
            :label=\"t(memberInfo)\"
            align=\"left\"
            min-width=\"200\"
          >
            <template #default=\"{ row }\">
              <div
                class=\"flex items-center cursor-pointer\"
                @click=\"toMember(row.member.member_id)\"
                v-if=\"row.member\"
              >
                <img
                  class=\"w-[50px] h-[50px] mr-[10px]\"
                  v-if=\"row.member.headimg\"
                  :src=\"img(row.member.headimg)\"
                  alt=\"\"
                />
                <img
                  class=\"w-[50px] h-[50px] mr-[10px]\"
                  v-else
                  src=\"@/app/assets/images/default_headimg.png\"
                  alt=\"\"
                />
                <div class=\"flex flex flex-col\">
                  <a
                    href=\"javascript:;\"
                    :title=\"row.member.nickname\"
                    class=\"multi-hidden\"
                    >{{ row.member.nickname }}</a
                  >
                  <span>{{ row.member.mobile || \"\" }}</span>
                </div>
              </div>
            </template>
          </el--column>

          <el--column label=\"使用时间\" min-width=\"180\" align=\"center\">
            <template #default=\"{ row }\">
              {{ row.start_time || \"\" }}
            </template>
          </el--column>
          <el--column
            :label=\"t(orderStatus)\"
            min-width=\"180\"
            align=\"center\"
          >
            <template #default=\"{ row }\">
              <div class=\"flex items-center\">
                {{ row.order_status_info.name }}
                <div v-if=\"row.order_status == 1\">
                  <el-tag class=\"ml-2\" type=\"info\" v-if=\"row.is_ticking == 1\"
                    >已出票</el-tag
                  >
                  <el-button
                    class=\"ml-2\"
                    v-if=\"row.is_ticking != 1\"
                    type=\"primary\"
                    plain
                    size=\"small\"
                    @click=\"editOrder(row.order_id)\"
                    >立即出票</el-button
                  >
                </div>
              </div>
            </template>
          </el--column>
          <el--column
            :label=\"t(operation)\"
            align=\"right\"
            fixed=\"right\"
            width=\"130\"
          >
            <template #default=\"{ row }\">
              <!-- <el-button class=\"ml-2\" v-if=\"row.is_ticking == 1\" type=\"primary\" link size=\"small\"
                @click=\"editOrder(row.order_id)\">重新出票</el-button> -->
              <el-button type=\"primary\" link @click=\"infoEvent(row)\">{{
                t(\"info\")
              }}</el-button>
            </template>
          </el--column>
        </el->
        <div class=\"mt-[16px] flex justify-between\">
          <el-button @click=\"Event()\">选中出票</el-button>
          <el-pagination
            v-model:current-page=\"order.page\"
            v-model:page-size=\"order.limit\"
            layout=\"total, sizes, prev, pager, next, jumper\"
            :total=\"order.total\"
            @size-change=\"loadOrderList()\"
            @current-change=\"loadOrderList\"
          />
        </div>
      </div>

      <!-- <order-edit ref=\"editOrderDialog\" @complete=\"loadOrderList\" /> -->
    </el-card>
  </div>
</template>


import { reactive, ref } from \"vue\";
import { t } from \"@/lang\";
import {
  getScenicOrderList,
  getScenicOrderStatus,
  changeIsTick,
  Ticket,
} from \"@/addon/tourism_tick/api/tourism\";
import { img } from \"@/utils/common\";
import { useRouter, useRoute } from \"vue-router\";
import { AnyObject } from \"@/types/global\";
import { ElMessageBox, FormInstance } from \"element-plus\";
// 选中数据
const Data = ref<any[]>([]);
const handleionChange = (val) => {
  Data.value = val.map((item) => item.order_id);
};
const Event = async () => {
  if (Data.value.length > 0) {
    Ticket(Data.value).then((res) => {
      loadOrderList();
    });
  } else {
    ElMessageBox.confirm(\"请先选择要出票的数据\", t(\"warning\"), {
      confirmButtonText: t(\"confirm\"),
      cancelButtonText: t(\"cancel\"),
      type: \"warning\",
    });
  }
};
const route = useRoute();
const router = useRouter();
const pageName = route.meta.title;

interface OrderType {
  page: number;
  limit: number;
  total: number;
  loading: boolean;
  data: AnyObject[];
  searchParam: {
    order_no: string;
    order_status: string;
    create_time: any[];
    start_time: any[];
    pay_time: any[];
    is_ticking?: string | number;
    status?: string | number;
  };
}
const order = reactive<OrderType>({
  page: 1,
  limit: 10,
  total: 0,
  loading: true,
  data: [],
  searchParam: {
    order_no: \"\",
    order_status: \"\",
    create_time: [],
    pay_time: [],
  },
});

const searchFormRef = ref<FormInstance>();
const editOrder = async (e) => {
  await changeIsTick(e);
  loadOrderList();
};
*
 * 获取订单列表
 */
const loadOrderList = (page: number = 1) => {
  order.loading = true;
  order.page = page;

  getScenicOrderList({
    page: order.page,
    limit: order.limit,
    ...order.searchParam,
  })
    .then((res) => {
      order.loading = false;
      order.data = res.data.data;
      order.total = res.data.total;
    })
    .catch(() => {
      order.loading = false;
    });
};
loadOrderList();

// 获取订单状态
interface OrderStatusType {
  name: string;
}
const orderStatus = ref<OrderStatusType[]>([]);
const checkOrderStatus = () => {
  getScenicOrderStatus().then((res) => {
    orderStatus.value = res.data;
  });
};
checkOrderStatus();

const infoEvent = (info: AnyObject) => {
  const routeData = router.resolve({
    path: \"/orderticking/orderticking_edit\",
    query: { order_id: info.order_id },
  });

  window.open(routeData.href, \"_blank\");
};

// 重置
const resetForm = (formEl: FormInstance | undefined) => {
  if (!formEl) return;
  formEl.resetFields();
  loadOrderList();
};



只需要合并num这一列','1',NULL,NULL,'1713107196');
INSERT INTO `{{prefix}}ai_msg` VALUES ('950','100000','u0z3maHCxv','system','```vue
<el--column
            prop=\"num\"
            min-width=\"180\"
            align=\"center\"
          />
```','1','0',NULL,'1713107201');
INSERT INTO `{{prefix}}ai_msg` VALUES ('951','100000','uZzdaoLWvH','user','写一个sql语句，往数据表aichat_member里面增加一个channel字段，字符串32','1',NULL,NULL,'1713109419');
INSERT INTO `{{prefix}}ai_msg` VALUES ('952','100000','uZzdaoLWvH','system','首先，我们需要使用ALTER TABLE语句来修改数据表结构，然后添加一个名为channel的字段，其类型为VARCHAR(32)。

以下是SQL语句：

```sql
ALTER TABLE aichat_member
ADD channel VARCHAR(32);
```','1','0',NULL,'1713109422');
