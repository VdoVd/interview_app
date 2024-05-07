import { homeSubItemModel, homeSubListModel } from '../../models/homeSubListModel'
import { http } from '@kit.NetworkKit'
import HomeSubListItemView from '../home/HomeSubListItemView'
import { allResponse } from '../../common/utils/myReq'
import { IvSkeleton } from '../../common/components/IvSkeleton'

@Component
export default struct searchListView{

  @Consume @Watch("searchReq") keyword:string
  @State listItems:homeSubItemModel[]=[]
  @State loadingFlag:boolean=true
  @State refreshing:boolean=false
  @State page:number=1
  @State timeId:number=0
  @Builder
  skeletonBuilder(){
    Column(){
      ForEach(Array.from({length:15}),(item:undefined)=>{
        Row({space:15}){
          IvSkeleton({widthValue:'30%',heightValue:20})
          IvSkeleton({widthValue:'60%',heightValue:20})
        }.padding(10)
      })
    }
  }
  searchReq(){
      console.log('start search')
      this.page=1
      this.loadingFlag = true
      this.loading()

  }
  private async loading() {
    if(this.keyword==='')return
    console.log('start loading...')
    let req = http.createHttp()
    const res = await req.request(`https://api-harmony-teach.itheima.net/hm/question/list?questionBankType=10&keyword=${this.keyword}&page=${this.page}`)
    let result = (JSON.parse(res.result.toString()) as allResponse<homeSubListModel>).data.rows
    console.log(`res is:${res.result}`)
    this.listItems = result
    this.loadingFlag=false
    this.keyword=''
    console.log('end loading...')
  }
  build() {
    Scroll(){
      Column(){
        Button('ok')
        Refresh({refreshing:$$this.refreshing}){
          List(){

              ForEach(this.listItems,(item:homeSubItemModel,index:number)=>{
                ListItem(){
                  HomeSubListItemView({item:item})
                }
              })

            ListItem(){
              Text('load...')
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