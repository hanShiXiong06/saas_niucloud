import request from '@/utils/request'

export function getTongji(params: Record<string, any>) {
    return request.get('blog/tongji', params)
}

export const complaint = (data) => {
  return request.get('blog/tie/complaint',{
    ...data
  })
} 
/**
 * 获取评论列表
 */
export const getBlogCommentApi = (data) => {
  return request.get('blog/Comment/commentlist',{
    ...data
  })
}


/**
 * 添加发表评论
 */
export const postBlogCommentApi = (data) => {
  return request.post('blog/Comment/tocomment',{
    ...data
  })
}
/**
 * 删除评论
 */
export const commentDel = (data) => {
  return request.post('blog/Comment/commentDel',{
    ...data
  })
}


/**
 * 获取博主关注详情
 */
export const getBlogInfoApi = ({...data}) => {
  return request.get('blog/Bloger/bloger_detail',{...data})
}


/**
 * 删除帖子
 */
export const delBlogApi = (id) => {
    return request.post('blog/Tie/tieDelete',{
        id
    })
}
/**
 * 评论点赞
 */
export const postCommentlikelApi = (data) => {
  return request.post('blog/Comment/tolikecomment',{
    ...data
  })
}


