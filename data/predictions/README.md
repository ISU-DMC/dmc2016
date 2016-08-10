## Predictions on latest test sets

Save predictions to csv file in the form:

```
binary,continuous
1,0.5334
1,0.5713
0,0.4128
..
..
..
```

If your model can only produce binary predictions, then just save the column of binary predictions. Name the file like ```[username]_[model].csv```. For example, ```epwalsh_xgboost.csv```.

> NOTE! For comparing predictions from V1 and V2, need to remove first row from V1 and last row from V2.
