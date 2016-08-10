# Parameter tuning

See [https://github.com/dmlc/xgboost/blob/master/doc/parameter.md](https://github.com/dmlc/xgboost/blob/master/doc/parameter.md)
for a full list of parameters.

## Feature matrix v05

Results from 5-fold cross-validation.

| mae (best round)    | objective       | max_depth | eta  | colsample_bytree |
| ------------------- | --------------- | --------- | ---- | ---------------- |
| 0.291575 (591)      | binary:logistic | 9         | 0.01 | 0.2              |
| **0.286724** (392)  | binary:logistic | 9         | 0.05 | 0.2              |
| 0.288401 (223)      | binary:logistic | 10        | 0.1  | 0.2              |
| 0.287942 (296)      | binary:logistic | 9         | 0.1  | 0.2              |
| 0.288294 (242)      | binary:logistic | 8         | 0.1  | 0.1              |
| 0.288228 (249)      | binary:logistic | 8         | 0.1  | 0.2              |
| 0.288627 (219)      | binary:logistic | 8         | 0.1  | 0.3              |
| 0.290411 (209)      | binary:logistic | 8         | 0.05 | 0.4              |
| 0.289020 (171)      | binary:logistic | 8         | 0.1  | 0.4              |
| 0.297138 (57)       | binary:logistic | 9         | 0.2  | 0.2              |
| 0.292148 (124)      | binary:logistic | 9         | 0.2  | 0.3              |
| 0.292261 (144)      | binary:logistic | 9         | 0.2  | 0.4              |
| 0.291788 (137)      | binary:logistic | 8         | 0.2  | 0.4              |
| 0.292088 (141)      | binary:logistic | 7         | 0.2  | 0.4              |
| 0.292933 (114)      | binary:logistic | 6         | 0.2  | 0.4              |
| 0.292494 (121)      | binary:logistic | 6         | 0.2  | 0.5              |
| 0.292560 (144)      | binary:logistic | 6         | 0.2  | 1                |
| 0.294963 (92)       | binary:logistic | 5         | 0.3  | 1                |
| 0.296493 (87)       | binary:logistic | 4         | 0.3  | 1                |
| 0.300439 (46)       | binary:logistic | 3         | 0.3  | 1                |
| 0.303055 (46)       | binary:logistic | 2         | 0.3  | 1                |
| 0.305426 (50)       | reg:linear      | 2         | 1    | 1                |
