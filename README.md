## About 
This environment is built on Travis' [single cell env](https://github.com/umich-brcf-bioinf/single_cell_env) with LIGER added on and some stuff removed.

## To modify

* update the Dockerfile as needed

* build and retag image:

```
docker build -t ncarrut/liger:zellkonverter --platform=linux/amd64 . 2>&1 | tee build.log
```

* push to docker hub:

```
docker push ncarrut/liger:zellkonverter
```

* git commit with tag and push to github

```
git add .
git commit -m "added zellkonverter"
git tag zellconverter
git push zellconverter
```