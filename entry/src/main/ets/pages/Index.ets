import { ImagePage } from './ImagePage'
import { TaskPage } from './TaskPage'
import { HomeworkPage } from './HomeworkPage'
import { HealthPage } from './HealthPage'

@Entry
@Component
struct Index {
  @State currentIndex: number = 0

  build() {
    Tabs({ index: this.currentIndex, barPosition: BarPosition.End }) {
      TabContent() {
        ImagePage()
      }
      .tabBar({
        icon: this.currentIndex === 0 ? $r('app.media.ic_image_selected') : $r('app.media.ic_image'),
        text: '图像'
      })

      TabContent() {
        TaskPage()
      }
      .tabBar({
        icon: this.currentIndex === 1 ? $r('app.media.ic_task_selected') : $r('app.media.ic_task'),
        text: '任务'
      })

      TabContent() {
        HomeworkPage()
      }
      .tabBar({
        icon: this.currentIndex === 2 ? $r('app.media.ic_homework_selected') : $r('app.media.ic_homework'),
        text: '作业'
      })

      TabContent() {
        HealthPage()
      }
      .tabBar({
        icon: this.currentIndex === 3 ? $r('app.media.ic_health_selected') : $r('app.media.ic_health'),
        text: '健康'
      })
    }
    .onChange((index: number) => {
      this.currentIndex = index
    })
  }
}
