import { ToastUtil } from '@pura/harmony-utils';


@Component
export default struct PageMy {
  scroller: Scroller = new Scroller();
  @State message: string = '我的内容';

  build() {
    Column(){
      Scroll(this.scroller) {
        Text(this.message)
      }.width('100%')
    }.width('100%')
    .height('100%')
    .backgroundColor('#00CB87')
    .justifyContent(FlexAlign.Center)
  }
}