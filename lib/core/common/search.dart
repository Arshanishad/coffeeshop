// setSearchParam(String caseNumber) {
//   List<String> caseSearchList = <String>[];
//   String temp = "";
//   List<String> nameSplits = caseNumber.split(" ");
//   for (int i = 0; i < nameSplits.length; i++) {
//     String name = "";
//     for (int k = i; k < nameSplits.length; k++) {
//       name = "$name${nameSplits[k]} ";
//     }
//     temp = "";
//     for (int j = 0; j < name.length; j++) {
//       temp = temp + name[j];
//       caseSearchList.add(temp.toUpperCase());
//     }
//   }
//   return caseSearchList;
// }


setSearchParam(String search){
  List<String> searchList=[];
  for(int i=0;i<=search.length;i++){
    for(int j=i+1;j<=search.length;j++){
      searchList.add(search.substring(i,j).toUpperCase().trim());
    }
  }
  return searchList;
}