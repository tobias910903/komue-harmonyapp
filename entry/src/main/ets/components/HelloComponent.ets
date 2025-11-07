@Component
struct HelloComponent {
  @State message: string = 'Hello, World!111';
  clickCallback?: () => void

  build() {
    // HelloComponent自定义组件组合系统组件Row和Text
    Row() {
      Text(this.message)
        .onClick(() => {
          // 状态变量message的改变驱动UI刷新，UI从'Hello, World!'刷新为'Hello, ArkUI!'
          this.message = 'Hello, ArkUI!111';

          if(this.clickCallback){
            this.clickCallback()
          }
        })
    }
  }
}

export {
  HelloComponent
}