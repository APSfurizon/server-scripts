FROM pretix/standalone:stable
USER root
ENV DJANGO_SETTINGS_MODULE=
RUN pip3 install pretix-xpay
RUN pip3 install pretix-autocart
RUN pip3 install fzbackendutils
ENV DJANGO_SETTINGS_MODULE=production_settings
RUN python3 --version
USER pretixuser

# Apply my "only N items in the first screen" patch
RUN cd /pretix/ && wget https://patch-diff.githubusercontent.com/raw/pretix/pretix/pull/4662.patch && git apply 4662.patch

RUN cd /pretix/src && make production
