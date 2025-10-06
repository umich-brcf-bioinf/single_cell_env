## About 
Updated the celltypist env [here](https://github.com/Teichlab/celltypist/blob/main/Dockerfile) to include ps which is required for nextflow

## To modify

* update the Dockerfile as needed

* build and retag image:

```
docker build -t ncarrut/celltypist_nextflow:update_bbknn --platform=linux/amd64 . 2>&1 | tee build.log
```

* push to docker hub:

```
docker push ncarrut/celltypist_nextflow:update_bbknn

```

* git commit with tag and push to github

```
git add .
git commit -m "added bbknn"
git tag bbknn
git push
```

push tag too
```
git push origin zellconverter
```

