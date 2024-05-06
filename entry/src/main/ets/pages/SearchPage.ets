import { IvSkeleton } from '../common/components/IvSkeleton'
import searchListView from '../views/search/searchList'

PersistentStorage.persistProp<string[]>('searchRecord',[])

@Entry
@Component
struct searchPage{
  @StorageLink('searchRecord') arr:string[]=[]
  @State searchText:string=''
  @State delete:boolean=false
  @Provide isSearch:boolean=false
  @Provide keyword:string=''
  @Provide isSearchSuccess:boolean=false
  @StorageLink('topHeight') topHeight:number=0
  @Provide isFinishLoad:boolean=false
  @Builder
  skeletonBuilder(){
      Column(){
        ForEach(Array.from({length:10}),(item:undefined)=>{
          Row(){
            IvSkeleton({widthValue:30,heightValue:40})
            IvSkeleton({widthValue:70,heightValue:40})
          }
        })
      }
  }
  build() {
    Navigation(){
      Scroll(){
        Column({space:16}){
          Column({space:10}){
            Row({space:10}){
              TextInput({placeholder:'请输入关键字',text:$$this.searchText})
                .onChange(()=>{
                  this.isFinishLoad=false
                  this.isSearchSuccess=false
                })
                .onSubmit(()=>{
                  this.arr.push(this.searchText)
                  this.keyword=this.searchText
                  this.searchText=''
                  this.isSearch=true
                  this.isSearchSuccess=true
                })
                .layoutWeight(1)
              if(this.searchText!='')
                Text('取消')
                  .fontColor(Color.Gray)
                  .onClick(()=>{this.searchText=''})
            }
            if(this.isFinishLoad===false){
              Row(){
                Text('搜索记录').layoutWeight(1).fontWeight(FontWeight.Bold).textAlign(TextAlign.Start).width('93%')
                if(this.delete===false)
                  Image($r('app.media.ic_common_delete'))
                    .width(20)
                    .onClick(()=>{
                      this.delete=true
                    })
                else{
                  Row({space:10}){
                    Text('全部删除').fontColor(Color.Gray).fontSize(13).onClick(()=>{
                      this.arr=[...[]]
                      this.delete=false
                    })
                    Text('|').fontSize(13).fontColor(Color.Gray)
                    Text('完成').fontColor(Color.Gray).fontSize(13).onClick(()=>{
                      this.delete=false
                    })
                  }
                }
              }
              .width('90%')
              Column(){
                Flex({wrap:FlexWrap.Wrap}){
                  ForEach(this.arr,(item:string,index:number)=>{
                    Row(){this.flexTextBuilder(item)}.onClick(()=>{
                    })
                  })
                }
                .width('93%')
                Column(){
                  Row(){
                    Text('搜索热榜').fontWeight(FontWeight.Bolder).fontSize(20)
                    Text('换一换').fontColor(Color.Gray).fontSize(12)
                  }.width('100%').justifyContent(FlexAlign.SpaceBetween)
                  Flex({wrap:FlexWrap.Wrap}){
                    Text('这里是按照搜索热排').width('50%').fontColor(Color.Gray).margin({top:10})
                    Text('限制长度是330px').width('50%').fontColor(Color.Gray).margin({top:10})
                    Text('这里是按照搜索热排').width('50%').fontColor(Color.Gray).margin({top:10})
                    Text('限制长度是330px').width('50%').fontColor(Color.Gray).margin({top:10})
                  }
                }.padding(20)
              }
            }
          }
          if(this.searchText==='')
            searchListView().layoutWeight(1)
        }.justifyContent(FlexAlign.Start)
      }.height('100%')
    }.title('刷个面试题')
    .titleMode(NavigationTitleMode.Mini)
    .padding({top:this.topHeight})
  }
  @Builder
  flexTextBuilder(text:string) {
    Text(text)
      .fontColor(Color.Gray)
      .backgroundColor('rgba(0,0,0,0.1)')
      .padding(6)
      .borderRadius(13)
      .margin(9)
  }
}