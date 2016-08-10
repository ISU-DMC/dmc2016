## Personal space for j23414

![](workspaceimg.jpg)

###Work directory setup on Mac, yes I am an apple person...
```
brew install git-lfs
git lfs install
git clone https://github.com/epwalsh/dmc2016.git

cd users/j23414/
ln -s ../../data/raw_data/orders_train.txt .
ln -s ../../data/raw_data/orders_class.txt .
# do stuff
```

###Creating and uploading feature files
```
./computeyourfeature.[pl/sh/etc...] orders_[train/class].txt > j23414_newfeature_[train/class].csv
zip j23414_newfeature.zip j23414_newfeature_train.csv j23414_newfeature_class.csv
cp j23414_newfeature.zip ../../data/features/[numeric/categorical]/.
emacs ../../data/features/README.md  # describe new feature
git lfs add ../../data/features/[numeric/categorical]/j23414_newfeature.zip
git commit -m "add X feature" ../../data/features/README.md \
    ../../data/features/[numeric/categorical]/j23414_newfeature* \
    computeyourfeature.*
git push origin master
```

###File Description

* **getRunningTotals.pl**:computes running totals for items purchased, orders made, and voucher amount used by customer
* **getCombinedRun.sh**: calls getRunningTotals.pl to calculate running total with respect to combined train+class data 
* **Report.Rnw**: playground to explore the data, Report.pdf is output
