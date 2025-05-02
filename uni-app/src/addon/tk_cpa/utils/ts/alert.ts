//带确定的函数弹窗

export async function confirm(t,f,v) {
	uni.showModal({
		title: '温馨提示',
		content: t,
		confirmColor: '#3a8f26',
		cancelColor: '#646464',
		success: function(res) {
			if (res.confirm) {
				f(v)
			} else if (res.cancel) {
				uni.$u.toast('取消了本次操作')
			}
		}
	});
}
//消息提示
export async function totast(t) {
	uni.$u.toast(t)
}


