import promptAction from '@ohos.promptAction'

// 兼容类型
interface DatePickerResult {
  year: number;
  month: number;
  day: number;
}

@Component
export struct HealthPage {
  @State school: string = ''
  @State gradeIndex: number = 0
  @State birthDate: Date = new Date(2008, 0, 1)
  @State exerciseMinutes: number = 30
  @State agree: boolean = false

  private grades: string[] = ['一年级', '二年级', '三年级', '四年级', '五年级', '六年级']
  private readonly startDate: Date = new Date(1980, 0, 1)
  private readonly endDate: Date = new Date(2035, 11, 31)

  build() {
    Scroll() {
      Column() {
        // 顶部标题
        Text('🏫 学生健康信息登记表')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(0xFF1E88E5)
          .margin({ top: 20, bottom: 20 })
          .alignSelf(ItemAlign.Center)

        // 表单卡片
        Column({ space: 20 }) {
          // 学校名称
          Column() {
            Text('学校名称')
              .fontSize(16).fontWeight(FontWeight.Medium)
              .margin({ bottom: 6 })
            TextInput({ placeholder: '请输入学校名称', text: this.school })
              .width('100%').height(44)
              .padding({ left: 12 })
              .backgroundColor('#F7F9FC')
              .borderRadius(10)
              .onChange((v: string) => { this.school = v })
          }

          Divider().strokeWidth(0.5).color('#E0E0E0')

          // 年级
          Column() {
            Text('选择年级')
              .fontSize(16).fontWeight(FontWeight.Medium)
              .margin({ bottom: 6 })
            TextPicker({ range: this.grades, selected: this.gradeIndex })
              .onChange((value: string | string[], index: number | number[]) => {
                const idx = Array.isArray(index) ? index[0] : index
                if (typeof idx === 'number') this.gradeIndex = idx
              })
            Text(`当前选择：${this.grades[this.gradeIndex]}`)
              .fontSize(14).fontColor(Color.Gray).margin({ top: 6 })
          }

          Divider().strokeWidth(0.5).color('#E0E0E0')

          // 出生日期
          Column() {
            Text('出生日期')
              .fontSize(16).fontWeight(FontWeight.Medium)
              .margin({ bottom: 6 })
            DatePicker({
              start: this.startDate,
              end: this.endDate,
              selected: this.birthDate
            })
              .onChange((res: DatePickerResult) => {
                this.birthDate = new Date(res.year, res.month - 1, res.day)
              })
            Text(`已选择：${this.birthDate.getFullYear()}年${this.birthDate.getMonth() + 1}月${this.birthDate.getDate()}日`)
              .fontSize(14).fontColor(Color.Gray).margin({ top: 6 })
          }

          Divider().strokeWidth(0.5).color('#E0E0E0')

          // 运动时长
          Column() {
            Text('每日运动时长（分钟）')
              .fontSize(16).fontWeight(FontWeight.Medium)
              .margin({ bottom: 6 })
            Slider({ value: this.exerciseMinutes, min: 0, max: 180, step: 10 })
              .onChange((v: number) => { this.exerciseMinutes = v })
            Text(`${this.exerciseMinutes} 分钟`)
              .fontSize(14).fontColor(0xFF1E88E5).margin({ top: 6 })
          }

          Divider().strokeWidth(0.5).color('#E0E0E0')

          // 协议
          Row({ space: 8 }) {
            Toggle({ type: ToggleType.Checkbox, isOn: this.agree })
              .onChange((v: boolean) => { this.agree = v })
            Text(this.agree ? '已同意隐私协议' : '未同意隐私协议')
              .fontSize(14)
              .fontColor(this.agree ? 0xFF4CAF50 : Color.Red)
          }

          // 提交按钮
          Button('提交信息')
            .width('100%').height(46)
            .backgroundColor(0xFF1E88E5)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
            .borderRadius(23)
            .shadow({ radius: 6, color: 0x33000000, offsetX: 0, offsetY: 3 })
            .onClick(() => {
              if (!this.agree) {
                promptAction.showToast({ message: '请先同意隐私协议' })
                return
              }
              const y = this.birthDate.getFullYear()
              const m = this.birthDate.getMonth() + 1
              const d = this.birthDate.getDate()
              const grade = this.grades[this.gradeIndex]
              promptAction.showToast({
                message: `提交成功：${this.school} / ${grade} / ${y}-${m}-${d} / ${this.exerciseMinutes}分钟`
              })
            })
        }
        .width('90%')
        .padding(20)
        .backgroundColor(Color.White)
        .borderRadius(16)
        .shadow({ radius: 10, color: 0x22000000, offsetX: 0, offsetY: 6 })
        .margin({ bottom: 30 })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%').height('100%')
    .backgroundColor('#F0F4F8')
  }
}
