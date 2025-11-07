import PageIndex from './index/PageIndex'
import PageMy from './index/PageMy'

@Entry
@Component
struct Index {
  @State selectedIndex: number = 0;
  @State currentIndex: number = 0;
  private controller: TabsController = new TabsController();

  onBackPress(): boolean {
    return false;
  }

  @Builder tabBuilder(title: string, targetIndex: number, icon: Resource, iconActive: Resource) {
    Column(){
      Image(this.selectedIndex === targetIndex ? iconActive : icon)
        .width(24)
        .height(24)
        .margin({ bottom: 4, top: 4 })
        .objectFit(ImageFit.Contain)

      Text(title)
        .fontColor(this.selectedIndex === targetIndex ? '#1698CE' : '#6B6B6B')
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, index: this.currentIndex, controller: this.controller }) {
        TabContent() {
          PageIndex()
        }.tabBar(this.tabBuilder('首页', 0, $r('app.media.icon_demo'), $r('app.media.icon_demo')))

        TabContent() {
          PageMy()
        }.tabBar(this.tabBuilder('我的', 1, $r('app.media.icon_demo'), $r('app.media.icon_demo')))
      }
      .vertical(false)
      .barMode(BarMode.Fixed)
      .barWidth('100%')
      .barHeight(60)
      .animationDuration(0)
      .onChange((index: number) => {
        this.currentIndex = index;
        this.selectedIndex = index;
      })
      .width('100%')
      .height('100%')
      .backgroundColor('#F1F3F5')
      .scrollable(true)
      // .onContentWillChange((currentIndex, comingIndex) => {
      //   if (comingIndex == 2) {
      //     return false;
      //   }
      //   return true;
      // })
    }.width('100%')
  }
}