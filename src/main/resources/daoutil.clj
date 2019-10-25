(ns daoutil)
(println "加载了src/main/resources/daoutil文件，这里一定要仔细，有可能会覆盖默认的配置哈")
(def config {
   :pageIndex "pageIndex"
   :pageSize "pageSize"
;   :pageDefaultSize 30
   :pageDefaultIndex 0
   :sortOrder "sortOrder"
   :sortField "sortField"
   :show-log  false
   :sqlLevel 3 ;0不打印sql、1打印sql、2打印sql和参数、3打印sql和参数和操作耗时
})