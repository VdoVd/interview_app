import { QuestionTypeModel } from '../../models/CategoryModel'
import { homeSubItemModel, homeSubListModel } from '../../models/homeSubListModel'
import { image } from '@kit.ImageKit'

@Component
export default struct HomeFilterView{

  @Link show:boolean

  @Link sort:number

  @Link typeId:number

  @Prop objs:QuestionTypeModel[]=[]

  @State isClickDifficult:boolean=false

  @State isClickView:boolean=false

  @State sortNumber:number=0

  @State selectNumber:number=0

  @Link FatherTabSelect:number

  build() {
    Column({space:15}){

      Row(){
        Text('重置').fontSize(15).layoutWeight(1)
        Text('筛选题目').fontSize(15).layoutWeight(1)
        Text('完成').fontSize(15)
          .onClick(()=>{
            this.show=false
          })
      }

      Text('题目排序')
        .width('100%')
        .textAlign(TextAlign.Start)
        .fontWeight(FontWeight.Bold)

      Row({space:20}){

        Text('默认')
          .fontColor(this.sortNumber===0?Color.Blue:Color.Gray)
          .backgroundColor('rgba(0,0,0,0.1)')
          .padding({left:14,right:14,top:8,bottom:8})
          .borderRadius(10)
          .onClick(()=>{
            this.sortNumber=0
          })


        Row({space:10}){
          if(this.isClickDifficult){
            ForEach(['全部','简单','一般','困难'],(item:string,index:number)=>{
              Text(item)
                .fontColor(this.sortNumber===1?Color.Blue:Color.Gray)
                .onClick(()=>{

                  if(index===0){
                      this.sort=0
                  }else if(index===1){

                  }else if(index===2){

                  }else{

                  }

                })

            })
          }else{
            Text('难易')
              .fontColor(this.sortNumber===1?Color.Blue:Color.Gray)

          }





          Column() {

            Image($r('sys.media.ohos_ic_public_arrow_down'))
              .size({ width: 12, height: 6 })
              .onClick(()=>{
                this.isClickDifficult=!this.isClickDifficult
              })

          }
        }
        .backgroundColor('rgba(0,0,0,0.1)')
        .padding({left:14,right:14,top:8,bottom:8})
        .borderRadius(10)
        .onClick(()=>{
          this.sortNumber=1
        })


        Row()
        {
          Text('浏览量')
            .fontColor(this.sortNumber===2?Color.Blue:Color.Gray)


          Column() {
            Image($r('sys.media.ohos_ic_public_arrow_up'))
              .size({ width: 12, height: 6 })
              .onClick(()=>{
                this.sort=20
              })

            Image($r('sys.media.ohos_ic_public_arrow_down'))
              .size({ width: 12, height: 6 })
              .onClick(()=>{
                this.sort=21
              })

          }
        }.backgroundColor('rgba(0,0,0,0.1)')
        .padding({left:14,right:14,top:8,bottom:8})
        .borderRadius(10)
        .onClick(()=>{
          this.sortNumber=2
        })

      }
      .width('100%')

      Text('选择阶段')
        .width('100%')
        .padding({left:14,right:14,top:8,bottom:8})
        .fontWeight(FontWeight.Bold)

      Flex({wrap:FlexWrap.Wrap}){

        Text('全部').margin({right:20})
          .fontColor(this.selectNumber===0?Color.Blue:Color.Gray)
          .backgroundColor('rgba(0,0,0,0.1)')
          .padding({left:14,right:14,top:8,bottom:8})
          .borderRadius(10)
          .onClick(()=>{
            this.selectNumber=0
          })

        ForEach(this.objs,(item:QuestionTypeModel,index:number)=>{

          Stack(){

            Text(item.name)
              .margin({right:20,bottom:15})
              .fontColor(this.selectNumber===index+1?Color.Blue:Color.Gray)
              .backgroundColor('rgba(0,0,0,0.1)')
              .padding({left:14,right:14,top:8,bottom:8})
              .borderRadius(10)
              .onClick(()=>{

                this.selectNumber=index+1

                this.typeId=item.id

                this.FatherTabSelect=index

              })

            if(item.displayNewestFlag===1)
              Image($r('app.media.new'))
                .width(30)
                .margin({right:8})

          }
          .alignContent(Alignment.TopEnd)

        })

      }



    }.height('100%')
    .width('100%')
    .padding(20)

  }

}