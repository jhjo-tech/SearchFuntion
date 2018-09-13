# SearchFuntion
<https://www.mediawiki.org/wiki/API:Opensearch> 를 사용해서 검색 기능을 구현해봤습니다.

한글자씩 입력할 때마다 실시간으로 검색 결과를 출력하고, 검색어에 색을 줘서 검색 결과에서 구분할수 있도록 하였습니다.

검색 히스토리는 최근 검색 순으로 보여지게 하였으며 최대 20개까지 볼수 있습니다. 20개가 넘어가면 가장 마지막 부터 지워지게 됩니다. 또 같은 단어로 검색을 하면 기존에 데이터를 지우고 새롭게 최근 검색으로 들어가게 됩니다.

또 앱을 지우지 않는 이상 검색 히스토리를 남아있도록 하기 위해 UserDefault를 사용해서 데이터를 저장한뒤 불러오도록 하였습니다.

아이콘은 X를 누르면 검색 히스토리가 삭제 되도록 구현하였습니다.

### **[동영상 보기]**

[![Watch the video](http://img.youtube.com/vi/nspI72RRgeI/1.jpg)](https://www.youtube.com/watch?v=nspI72RRgeI&t=0s)

