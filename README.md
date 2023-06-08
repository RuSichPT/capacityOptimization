# Сapacity optimization
Оптимизация пропускной способности для Massive MIMO систем

## Подмодули
В этом проекте используется 2 подмодуля:
* matlabFunctions - библиотека моих функций
* QuaDRiGa (сокращение от QUAsi) - детерминированный генератор радиоканала, используется для создания реалистичных импульсных характеристик радиоканала для моделирования сетей мобильной радиосвязи на системном уровне.

Чтобы скачать подмодули выполните команду:

	git submodule update

Или скачать по ссылкам и распаковать в соответствующие папки
https://github.com/fraunhoferhhi/QuaDRiGa  
https://github.com/RuSichPT/matlabFunctions    

## Capacity скрипты

Если возникли проблемы с путями к QuaDRiGa и другим папкам запустите скрипт
    
    startup.m

* **compareCapacity.m** - для просмотра средней пропускной способности для модели канала по Кронекеру с заданной апертурой 6 x 3.6
с пространственной корреляцией.  

* **compareCapacity2.m** - для сравнения средней пропускной способности с пространственной корреляцией и без нее.    

* **watchCDFQuaDRiGa.m** - для просмотра функции распределения (CDF) и плотности вероятности (PDF) для углов AoD и EoD.

* **watchCDFQuaDRiGa2.m** - для просмотра PDF для углов AoD и EoD для omni и dipole антенных элементов.

* **calculateCapacity.m** - расчет пропускной способности для модели канала по Кронекеру.

* **testGenerate3GPPChannel.m** - пример построения функции распределения (CDF) пропускной способности.

* **antennaPattern.m** - для просмотра диаграммы направленности (ДН) элемента антенной решетки. 

* **calculateABSD.m** - для генерации коэффициентов A B C D, чтобы задать аналитически ДН антенного элемента.

* **capacityOnNumTx.m** - для просмотра средней пропускной способности от отношения числа антенн на передачу к числу на приеме. 

* **capacityOnNumTx2.m** - для сравнения средней пропускной способности с пространственной корреляцией и без нее. 

Скрипты для генерации канала, расчета пропускной способности и сохранения данных в mat файл
* **generate/generateChannels.m** - ручная генерация канала.

* **generate/autoGenerateChannelsSize.m** - автоматическая генерация канала с изменением **размера решетки**.

* **generate/autoGenerateChannelsSpacing.m** - автоматическая генерация канала с изменением **расстояния между элементами**.

Скрипты для построение графика функции распределения (CDF) пропускной способности по сгенерированным данным (На github данных нет, они тяжелые. Можно сгенерировать функциями выше):
* dataBase/**analyzeOmni.m** - для решетки с элементом **'omni'**.
  
* dataBase/**analyzeDipole.m** - для решетки с элементом **'dipole'**.

* dataBase/**analyze3Gppmmw.m** - для решетки **'3gpp-mmw'**. 

## Optimization скрипты

* **optimizCapacity.m** - скрипт расчета аналитической пропускной способности и решение оптимизационной задачи для ULA как в статье
"Capacity Analysis and Optimal Spacing Design for Compact Array Massive MIMO Systems With Finite Aperture".
