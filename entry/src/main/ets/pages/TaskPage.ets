interface Task { id: number; title: string; done: boolean; }
interface SwipeState { id: number; offsetX: number; }

function makeSwipeState(id: number, offsetX: number): SwipeState { return { id, offsetX }; }

@Component
export struct TaskPage {
  @State tasks: Task[] = [
    { id: 1, title: '学习 HarmonyOS ArkTS', done: false },
    { id: 2, title: '完成作业页面 UI', done: true },
    { id: 3, title: '优化底部导航图标', done: false }
  ]

  @State swipeStates: SwipeState[] = [
    makeSwipeState(1, 0),
    makeSwipeState(2, 0),
    makeSwipeState(3, 0)
  ]

  private nextId: number = 4
  private readonly maxReveal: number = 96
  private readonly trigger: number = 56

  // ---------- 工具 ----------
  private clamp(v: number, min: number, max: number): number {
    return Math.max(min, Math.min(max, v))
  }
  private getOffset(id: number): number {
    const s = this.swipeStates.find(x => x.id === id)
    return s ? s.offsetX : 0
  }
  private setOffset(id: number, val: number): void {
    this.swipeStates = this.swipeStates.map(x => x.id === id ? makeSwipeState(x.id, val) : x)
  }

  // ---------- 行为 ----------
  toggleDone(id: number, val: boolean): void {
    this.tasks = this.tasks.map(item => {
      if (item.id === id) {
        return { id: item.id, title: item.title, done: val }
      }
      return item
    })
  }

  deleteTask(id: number): void {
    this.tasks = this.tasks.filter(item => item.id !== id)
    this.swipeStates = this.swipeStates.filter(s => s.id !== id)
  }

  addTask(title: string): void {
    const task: Task = { id: this.nextId++, title: title, done: false }
    // ✅ 使用 concat 而不是 ... 展开
    this.tasks = [task].concat(this.tasks)
    this.swipeStates = [makeSwipeState(task.id, 0)].concat(this.swipeStates)
  }

  // ---------- UI ----------
  build() {
    Column() {
      // 顶部统计卡片
      Column() {
        Text(`任务总数: ${this.tasks.length}`)
          .fontSize(18).fontWeight(FontWeight.Bold).margin({ bottom: 6 })
        Text(`已完成: ${this.tasks.filter(item => item.done).length}   未完成: ${this.tasks.filter(item => !item.done).length}`)
          .fontSize(14).fontColor(Color.Gray)
      }
      .width('90%')
      .padding(16)
      .backgroundColor(Color.White)
      .borderRadius(12)
      .shadow({ radius: 6, color: 0x22000000, offsetX: 0, offsetY: 2 })
      .margin({ top: 12, bottom: 12 })
      .alignItems(HorizontalAlign.Center)

      // 列表
      List({ space: 12 }) {
        ForEach(this.tasks,
          (item: Task) => {
            ListItem() {
              Stack({ alignContent: Alignment.Center }) {
                // 底层删除
                Row() {
                  Blank().width('1fr')
                  Button('删除')
                    .backgroundColor(0xFFE53935).fontColor(Color.White)
                    .borderRadius(12).width(this.maxReveal - 16).height(44)
                    .onClick(() => { this.deleteTask(item.id) })
                    .margin(6)
                }
                .width('100%').height(68)

                // 上层内容
                Row() {
                  Toggle({ type: ToggleType.Checkbox, isOn: item.done })
                    .onChange((checked: boolean) => { this.toggleDone(item.id, checked) })
                    .margin({ right: 12 })

                  Text(item.title)
                    .fontSize(18)
                    .decoration(item.done
                      ? { type: TextDecorationType.LineThrough }
                      : { type: TextDecorationType.None })
                    .flexGrow(1)
                    .maxLines(1)
                }
                .width('100%').height(68)
                .padding({ left: 16, right: 16 })
                .backgroundColor(Color.White)
                .borderRadius(12)
                .shadow({ radius: 6, color: 0x22000000, offsetX: 0, offsetY: 2 })
                .translate({ x: this.getOffset(item.id), y: 0 })
                .gesture(
                  PanGesture({ direction: PanDirection.Horizontal })
                    .onActionUpdate((ev: PanGestureEvent) => {
                      const next = this.clamp(this.getOffset(item.id) + ev.offsetX, -this.maxReveal, 0)
                      this.setOffset(item.id, next)
                    })
                    .onActionEnd((_ev: PanGestureEvent) => {
                      const finalX = (Math.abs(this.getOffset(item.id)) > this.trigger) ? -this.maxReveal : 0
                      this.setOffset(item.id, finalX)
                    })
                )
              }
              .width('100%')
            }
          },
          (item: Task, _index: number) => item.id.toString()
        )
      }
      .width('100%').height('1fr').edgeEffect(EdgeEffect.None)
      .padding({ left: 12, right: 12 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(0xFFF5F6FA)
  }
}
