## Emulator Pixel 3a 34 extesion 7 arm64-v8a

Following I cut some log samples of the execution in diverse contexts.

#### useIsolates = false useTopLevelFunction = false
 frequency -1.0 - intensity 0.47335686156100465 taken: 50 ms

 frequency -1.0 - intensity 0.49310675448197644 taken: 50 ms

 frequency -1.0 - intensity 0.4333803557275228 taken: 34 ms

 frequency -1.0 - intensity 0.40102166924185856 taken: 44 ms
 
<img width="777" alt="Captura de Tela 2023-09-14 às 12 12 28" src="https://github.com/matheuslmpereira/flutter-audio-analiser/assets/11295011/1e93cda7-6a21-4525-bb15-e7b9cac85566">

 #### useIsolates = false useTopLevelFunction = true
 frequency -1.0 - intensity 0.3685798668777788 taken: 50 ms
 
 frequency -1.0 - intensity 0.35286486219534 taken: 50 ms
 
 frequency -1.0 - intensity 0.35891335875138936 taken: 60 ms
 
 frequency -1.0 - intensity 0.35779834815083617 taken: 43 ms
 
 <img width="775" alt="Captura de Tela 2023-09-14 às 12 14 04" src="https://github.com/matheuslmpereira/flutter-audio-analiser/assets/11295011/1a496d74-0664-4b69-afa0-7d74efbefec1">


 #### useIsolates = true useTopLevelFunction = true
 
 frequency -1.0 - intensity 0.34121313921702595 taken: 51 ms
 
 frequency -1.0 - intensity 0.4256516694521851 taken: 51 ms
 
 frequency -1.0 - intensity 0.4504803777319334 taken: 50 ms
 
 frequency -1.0 - intensity 0.40538402801501333 taken: 43 ms
 
 <img width="775" alt="Captura de Tela 2023-09-14 às 12 14 59" src="https://github.com/matheuslmpereira/flutter-audio-analiser/assets/11295011/82245ba4-cc74-471d-b8d7-79002381b5ae">

## Xiaomi Readmi Note 8
#### useIsolates = true useTopLevelFunction = true

frequency -1.0 - intensity 0.2589397967382592 taken: 113 ms

frequency -1.0 - intensity 0.2827250995834817 taken: 113 ms

frequency -1.0 - intensity 0.3299044323927357 taken: 114 ms

frequency -1.0 - intensity 0.3074379605595631 taken: 112 ms

frequency -1.0 - intensity 0.3685798668777788 taken: 114 ms

<img width="777" alt="image" src="https://github.com/matheuslmpereira/flutter-audio-analiser/assets/11295011/3170b37d-bd0e-4552-a548-a21a006c4b9f">

#### useIsolates = false useTopLevelFunction = true

frequency -1.0 - intensity 0.3833814366254181 taken: 111 ms

frequency -1.0 - intensity 0.36823312461068625 taken: 111 ms

frequency -1.0 - intensity 0.30796533756285466 taken: 111 ms

frequency -1.0 - intensity 0.3200781690609104 taken: 110 ms

frequency -1.0 - intensity 0.3753458097874669 taken: 110 ms

<img width="779" alt="image" src="https://github.com/matheuslmpereira/flutter-audio-analiser/assets/11295011/dec19621-9529-418a-9f7c-5238d3ce7ef6">

#### useIsolates = false useTopLevelFunction = false

frequency -1.0 - intensity 0.3802205069570444 taken: 112 ms

frequency -1.0 - intensity 0.3689257806081986 taken: 113 ms

frequency -1.0 - intensity 0.5582049122058358 taken: 126 ms

frequency -1.0 - intensity 0.6115391374791106 taken: 103 ms

frequency -1.0 - intensity 0.2544389732703767 taken: 112 ms

<img width="778" alt="image" src="https://github.com/matheuslmpereira/flutter-audio-analiser/assets/11295011/0a6b6d5e-11f5-4990-8251-7facd930acc8">

#### Native Execution

requency -1.0 - intensity 0.6829975486187615 taken: 1 ms

requency -1.0 - intensity 0.5616221672799621 taken: 1 ms

requency -1.0 - intensity 0.5838334100058248 taken: 1 ms

requency -1.0 - intensity 0.5343862280273544 taken: 1 ms

requency -1.0 - intensity 0.9593678087354215 taken: 1 ms

<img width="777" alt="image" src="https://github.com/matheuslmpereira/flutter-audio-analiser/assets/11295011/3d7296a4-ec0e-4219-a951-501ee4de1ef5">
