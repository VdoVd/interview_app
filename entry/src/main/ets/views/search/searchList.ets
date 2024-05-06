import { homeSubItemModel, homeSubListModel } from '../../models/homeSubListModel'
import { http } from '@kit.NetworkKit'
import HomeSubListItemView from '../home/HomeSubListItemView'
import { allResponse } from '../../common/utils/myReq'
import { IvSkeleton } from '../../common/components/IvSkeleton'

@Component
export default struct searchListView{

  @Consume keyword:string
  @State listItems:homeSubItemModel[]=[]
  @State loadingFlag:boolean=true
  @Consume @Watch("searchReq")  isSearch:boolean
  @Consume @Watch("searchReq") isSearchSuccess:boolean
  @Consume isFinishLoad:boolean
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
    if(this.isSearch===true) {
      this.loadingFlag = true
      this.loading()
    }
  }
  private async loading() {
    console.log('start loading...')
    let req = http.createHttp()
    const res = await req.request(`https://api-harmony-teach.itheima.net/hm/question/list?questionBankType=10&keyword=vue`)
    let result = (JSON.parse(res.result.toString()) as allResponse<homeSubListModel>).data.rows
    if(result!=undefined)this.isSearchSuccess=true
    this.listItems = result
    this.isSearch=false
    this.loadingFlag=false
    this.keyword=''
    this.isFinishLoad=true
    console.log('end loading...')
  }
  build() {
    Column(){


      List(){
        if(this.isSearchSuccess=true)
        ForEach(this.listItems,(item:homeSubItemModel,index:number)=>{
          ListItem(){
            HomeSubListItemView({item:item})
          }
        })
        else
        ListItem(){
          Text('load...')
          this.skeletonBuilder()
        }
      }.width('100%').padding(20).layoutWeight(1)

    }
  }
}