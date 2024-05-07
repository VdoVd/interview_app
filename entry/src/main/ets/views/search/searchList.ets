import { homeSubItemModel, homeSubListModel } from '../../models/homeSubListModel'
import { http } from '@kit.NetworkKit'
import HomeSubListItemView from '../home/HomeSubListItemView'
import { allResponse } from '../../common/utils/myReq'
import { IvSkeleton } from '../../common/components/IvSkeleton'
import { router } from '@kit.ArkUI'

@Component
export default struct searchListView{

  @StorageLink('subList') list:homeSubItemModel[]=[]

  @Consume @Watch('searchReq') word:string
  // @Consume @Watch('changeIt') num:number

  @State listItems:homeSubItemModel[]=[]
  @State loadingFlag:boolean=true
  @State refreshing:boolean=false
  @State page:number=1
  @State timeId:number=0

  changeIt(){
    console.log('key change')
  }

  searchReq(){
    console.log('start search')
    this.page=1
    this.loadingFlag = true
    this.loading()
  }

  // aboutToAppear(): void {
  //
  // }
  //
  @Builder
  skeletonBuilder() {
    Column() {
      ForEach(Array.from({ length: 15 }), (item: undefined) => {
        Row({ space: 15 }) {
          IvSkeleton({ widthValue: '50%', heightValue: 20 })
          IvSkeleton({ widthValue: '50%', heightValue: 20 })
        }.padding(10)

        Row({ space: 15 }) {
          IvSkeleton({ widthValue: '40%', heightValue: 20 })
          IvSkeleton({ widthValue: '60%', heightValue: 20 })
        }.padding(10)

        Row({ space: 15 }) {
          IvSkeleton({ widthValue: '30%', heightValue: 20 })
          IvSkeleton({ widthValue: '70%', heightValue: 20 })
        }.padding(10)

        Row({ space: 15 }) {
          IvSkeleton({ widthValue: '20%', heightValue: 20 })
          IvSkeleton({ widthValue: '80%', heightValue: 20 })
        }.padding(10)

        Row({ space: 15 }) {
          IvSkeleton({ widthValue: '10%', heightValue: 20 })
          IvSkeleton({ widthValue: '90%', heightValue: 20 })
        }.padding(10)
      })
    }
  }





  private async loading() {
    // if(this.word==='') {
    //   console.log('keyword is empty')
    //   return
    // }
    console.log('start loading...')
    let req = http.createHttp()
    const res = await req.request(`https://api-harmony-teach.itheima.net/hm/question/list?questionBankType=10&keyword=${this.word}&page=${this.page}`)
    let result = (JSON.parse(res.result.toString()) as allResponse<homeSubListModel>).data.rows
    console.log(`res is:${res.result}`)
    this.listItems = result
    this.list=[...this.listItems]
    this.loadingFlag=false
    this.word=''
    console.log('end loading...')
  }

  build() {
    Column(){
      Scroll(){
        Column(){
          Refresh({refreshing:$$this.refreshing}){
            List(){
              if(this.loadingFlag===false)
                ForEach(this.listItems,(item:homeSubItemModel,index:number)=>{
                  ListItem(){
                    HomeSubListItemView({item:item})
                      .onClick(()=>{
                        router.pushUrl({
                          url:"pages/questionDetailPage",
                          params:{
                            id:item.id
                          }
                        })
                      })
                  }
                })
              if(this.loadingFlag===true)
              ListItem(){
                this.skeletonBuilder()
              }
            }.width('100%').padding(20).layoutWeight(1)
          }
          .onRefreshing(()=>{
            clearTimeout(this.timeId)
            this.timeId=setTimeout(()=>{

              this.page++

              this.loading()

              this.refreshing=false

            },300)
          })
        }
      }.height('100%')

    }
  }
}