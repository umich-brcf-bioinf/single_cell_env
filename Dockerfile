FROM python:3.9-slim

ENV CELLTYPIST_FOLDER="/opt/celltypist"
ENV PATH="$CELLTYPIST_FOLDER/bin:$PATH"

RUN apt-get update && \
    apt-get install -y build-essential

RUN python -m pip install --upgrade pip && \
    python -m venv $CELLTYPIST_FOLDER && \
    pip install wheel --no-cache-dir && \
    pip install celltypist --no-cache-dir && \
    pip install bbknn && \
    celltypist --update-models

CMD ["celltypist", "--help"]

RUN apt-get install -y procps && rm -rf /var/lib/apt/lists/*