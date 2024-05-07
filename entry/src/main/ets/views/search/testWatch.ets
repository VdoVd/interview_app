import { promptAction } from '@kit.ArkUI'

@Component
export default struct testWatch{
  @Consume @Watch("inc") num:number

  inc(){
    promptAction.showToast({message:'val change'})
  }
  build() {

    Column(){
        Button(`${this.num}`)
    }

  }

}