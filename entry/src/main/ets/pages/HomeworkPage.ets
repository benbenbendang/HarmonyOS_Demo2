import promptAction from '@ohos.promptAction'

interface Homework {
  name: string
  title: string
  content: string
  status: string
  tech: string
}

@Component
export struct HomeworkPage {
  @State name: string = ''
  @State title: string = ''
  @State content: string = ''
  @State status: string = '未完成'
  @State tech: string = ''
  @State submissions: Homework[] = []

  build() {
    Scroll() {
      Column({ space: 20 }) {
        // 🔹 页面标题
        Text('📘 学生作业提交表单')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1E3A8A')
          .margin({ top: 20, bottom: 10 })
          .alignSelf(ItemAlign.Center)

        // 🔹 表单卡片
        Column({ space: 18 }) {
          // 输入项封装
          this.renderInput('姓名', '请输入姓名', this.name, v => this.name = v)
          this.renderInput('标题', '请输入作业标题', this.title, v => this.title = v)
          this.renderTextArea('内容', '请输入作业详细内容...', this.content, v => this.content = v)

          // 是否完成
          Column({ space: 8 }) {
            Text('是否完成').fontSize(16).fontWeight(FontWeight.Medium)
            Row({ space: 20 }) {
              this.renderRadio('已完成', this.status === '已完成', () => this.status = '已完成')
              this.renderRadio('未完成', this.status === '未完成', () => this.status = '未完成')
            }
          }

          // 使用技术
          Column({ space: 8 }) {
            Text('使用技术').fontSize(16).fontWeight(FontWeight.Medium)
            Column({ space: 10 }) {
              this.renderRadio('ArkTS', this.tech === 'ArkTS', () => this.tech = 'ArkTS')
              this.renderRadio('JavaScript', this.tech === 'JavaScript', () => this.tech = 'JavaScript')
              this.renderRadio('CSS', this.tech === 'CSS', () => this.tech = 'CSS')
            }
          }

          // 提交按钮
          Button('提交作业')
            .width('100%').height(50)
            .fontSize(18).fontWeight(FontWeight.Bold)
            .backgroundColor('#3B82F6')
            .fontColor(Color.White)
            .borderRadius(25)
            .shadow({ radius: 6, color: 0x33000000, offsetX: 0, offsetY: 3 })
            .onClick(() => {
              if (this.name.trim() === '' || this.title.trim() === '') {
                promptAction.showToast({ message: '请输入姓名和标题' })
                return
              }
              const hw: Homework = {
                name: this.name,
                title: this.title,
                content: this.content,
                status: this.status,
                tech: this.tech
              }
              this.submissions = [hw, ...this.submissions]
              promptAction.showToast({ message: `✅ 提交成功: ${this.title}` })

              // 清空
              this.name = ''
              this.title = ''
              this.content = ''
              this.status = '未完成'
              this.tech = ''
            })
        }
        .width('90%')
        .padding(20)
        .backgroundColor(Color.White)
        .borderRadius(16)
        .shadow({ radius: 10, color: 0x22000000, offsetX: 0, offsetY: 6 })

        // 🔹 提交记录展示
        if (this.submissions.length > 0) {
          Column({ space: 12 }) {
            Text('📝 最近提交记录')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1E3A8A')
              .margin({ bottom: 6 })

            ForEach(this.submissions, (item: Homework, index: number) => {
              Column({ space: 4 }) {
                Text(`${item.name} - ${item.title}`)
                  .fontSize(16).fontWeight(FontWeight.Medium).fontColor(Color.Black)
                Text(`内容: ${item.content}`)
                  .fontSize(14).fontColor(Color.Gray)
                Text(`状态: ${item.status} ｜ 技术: ${item.tech}`)
                  .fontSize(14).fontColor('#2563EB')
              }
              .width('100%')
              .padding(14)
              .backgroundColor('#F9FAFB')
              .borderRadius(12)
              .shadow({ radius: 4, color: 0x22000000, offsetX: 0, offsetY: 2 })
            }, (item: Homework) => item.title + item.name)
          }
          .width('90%')
        }
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .padding({ bottom: 30 })
    }
    .width('100%').height('100%')
    .backgroundColor('#EEF2FF')
  }

  // ===== 封装一些控件，减少重复 =====
  @Builder
  private renderInput(label: string, placeholder: string, value: string, onChange: (v: string) => void) {
    Column() {
      Text(label).fontSize(16).fontWeight(FontWeight.Medium).margin({ bottom: 6 })
      TextInput({ placeholder: placeholder, text: value })
        .onChange(v => onChange(v))
        .width('100%').height(44)
        .padding({ left: 12 })
        .backgroundColor('#F3F4F6')
        .borderRadius(8)
    }
  }
  @Builder
  private renderTextArea(label: string, placeholder: string, value: string, onChange: (v: string) => void) {
    Column() {
      Text(label).fontSize(16).fontWeight(FontWeight.Medium).margin({ bottom: 6 })
      TextInput({ placeholder: placeholder, text: value })
        .onChange(v => onChange(v))
        .width('100%').height(100)
        .padding({ left: 12, top: 10 })
        .backgroundColor('#F3F4F6')
        .borderRadius(8)
    }
  }
  @Builder
  private renderRadio(text: string, checked: boolean, onSelect: () => void) {
    Row({ space: 8 }) {
      Radio({ value: text, group: text })
        .checked(checked)
        .onChange(isChecked => { if (isChecked) onSelect() })
      Text(text).fontSize(15)
    }
  }
}
