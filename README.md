# Сapacity optimization
Оптимизация пропускной способности для Massive MIMO систем

## Подмодули
В этом проекте используется 2 подмодуля:
* matlabFunctions - библиотека моих функций
* QuaDRiGa (сокращение от QUAsi) - детерминированный генератор радиоканала, используется для создания реалистичных импульсных характеристик радиоканала для моделирования сетей мобильной радиосвязи на системном уровне.

Чтобы скачать подмодули выполните команду:

	git submodule update

## Capacity скрипты

* watchCDFQuaDRiGa.m - для просмотра функции распределения (CDF) и плотности вероятности (PDF) для углов AoD EoD

* testGenerate3GPPChannel.m - посмотреть пример генерации канала 3GPP 

* calculateCapacity.m - расчет пропускной способности для модели канала по Кронекеру и QuaDRiGa (не работает пока)

## Optimization скрипты

* optimizCapacity.m - скрипт расчета аналитической пропускной способности и решение оптимизационной задачи для ULA как в статье
"Capacity Analysis and Optimal Spacing Design for Compact Array Massive MIMO Systems With Finite Aperture"