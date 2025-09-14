@Component
export struct ImagePage {
  private images: Resource[] = [
    $r('app.media.img5'),
    $r('app.media.img2'),
    $r('app.media.img3'),
    $r('app.media.img4')
  ]

  @State currentIndex: number = 0
  @State autoPlay: boolean = false
  @State imgOpacity: number = 1.0
  private timerId: number | null = null

  build() {
    Column() {
      // 图片展示卡片
      Column() {
        Image(this.images[this.currentIndex])
          .objectFit(ImageFit.Contain)
          .width('100%')
          .height('100%')
          .opacity(this.imgOpacity)
          .borderRadius(12)
      }
      .width('90%')
      .height('60%')
      .backgroundColor(Color.White)
      .borderRadius(16)
      .shadow({ radius: 10, color: 0x22000000, offsetX: 0, offsetY: 4 })
      .margin({ top: 20, bottom: 20 })
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)

      // 控制按钮区
      Row({ space: 12 }) {
        Button('上一张')
          .backgroundColor(0xFFE0E0E0)
          .fontColor(Color.Black)
          .borderRadius(20)
          .onClick(() => this.prev())

        Button(this.autoPlay ? '停止自动播放' : '开始自动播放')
          .backgroundColor(this.autoPlay ? 0xFFD32F2F : 0xFF1E88E5)
          .fontColor(Color.White)
          .borderRadius(20)
          .onClick(() => this.toggleAutoPlay())

        Button('下一张')
          .backgroundColor(0xFFE0E0E0)
          .fontColor(Color.Black)
          .borderRadius(20)
          .onClick(() => this.next())
      }
      .margin({ bottom: 20 })
      .justifyContent(FlexAlign.Center)

      // 透明度调节卡片
      Column() {
        Text(`透明度：${Math.round(this.imgOpacity * 100)}%`)
          .fontSize(16)
          .fontColor(0xFF333333)
          .margin({ bottom: 10 })

        Slider({ value: this.imgOpacity, min: 0, max: 1, step: 0.01 })
          .onChange((value: number) => { this.imgOpacity = value })
      }
      .width('90%')
      .padding(16)
      .backgroundColor(Color.White)
      .borderRadius(16)
      .shadow({ radius: 8, color: 0x22000000, offsetX: 0, offsetY: 3 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(0xFFF0F2F5)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  prev() {
    this.currentIndex =
      this.currentIndex > 0 ? this.currentIndex - 1 : this.images.length - 1
  }

  next() {
    this.currentIndex =
      this.currentIndex < this.images.length - 1 ? this.currentIndex + 1 : 0
  }

  toggleAutoPlay() {
    if (this.autoPlay) {
      this.autoPlay = false
      if (this.timerId !== null) {
        clearInterval(this.timerId)
        this.timerId = null
      }
    } else {
      this.autoPlay = true
      this.timerId = setInterval((): void => this.next(), 3000)
    }
  }
}
