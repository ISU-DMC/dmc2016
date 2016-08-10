**Rodrigo**: Good afternoon, my name is Rodrigo.

**Pete**: And my name is Pete. We are Iowa State University team number 2.

Since you've learned a bit about Iowa from our classmates, team number 1, ```change slide``` it's time for a geography quiz. 

Which state is Iowa? ```change slide``` Is it A...?

```change slide``` Is is it B...?

```change slide``` Or is it C...?

Actually it is none of those, ```change slide``` THIS is Iowa. (Haha)

Okay let's get serious. ```change slide``` So these are the tools that we used.

This figure depicts all of the R and Python modules that we were used in our code - the bigger the fontsize, the more often that module was used.

```change slide``` From the onset of the competition, one of our main focuses was on feature engineering.

```change slide``` In particular, we sought to categorize and understand customer behavior and how that related to returnQuantity.
We did so by clustering customers by their habits, such as the frequency of their visits, the quantities and number of different items bought.

We also dealt with size and price by standardizing within productGroup.

After creating several hundred "intuitive features" we then resorted to taking combinations of existing features, such as sums, products, and differences.

```change slide``` We had to take a different approach to categorical variables since most machine learning algorithms cannot deal with categorical variables directly.

One option, of course, is one-hot encoding, where each level within each categorical variable is transformed into an indicator variable.
The problem with this method is that the number of variables increases drastically, and most of these variables are useless.

Theoretically tree-based algorithms are not affected by useless features, but in practice this can be cumbersome to deal with.

```change slide``` An alternative is to map categorical variables to meaningful continuous features using a function of that variable and the response.

Of course this creates the issue of leakage, which is when too much specific information about the response is "leaked" into training set, causing the model to overfit.
To deal with this, we only create these variables based on a completely separate "historical" set with which we never train on.

```change slide``` A transformation of the variables sizeCode would go like this. Each row with sizeCode equal to small would be transformed using this statistic:

The log of the fraction that has the number of observations with small sizeCode and returnQuantity >= 1 as the numerator and the number of obervations with sizeCode small and 
returnQuantity 0 in the denominator.

Since these quantities could be null, we also add a small term to the top and bottom of the fraction which is chosen in Bayesian way.

In this way each categorical variable is mapped to a meaningful continuous variable, and we also do this for all two and three-way combinations of categorical variables.

```change slide```

**Rodrigo**:
