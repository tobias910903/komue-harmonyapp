@Component
export default struct PageIndex {
  // scroller: Scroller = new Scroller();
  @State message: string = '首页内容';

  aboutToAppear(): void {
    console.log("加载首页")
  }

  aboutToDisappear(): void {
    console.log("关闭首页")
  }

  build() {
      Column(){
        Text(this.message)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#ffcccc')
      .justifyContent(FlexAlign.Center)
  }
}
