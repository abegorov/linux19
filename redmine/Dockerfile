ARG REDMINE_VERSION

FROM redmine:${REDMINE_VERSION}
USER redmine

RUN mkdir plugin_assets

RUN git clone https://github.com/farend/redmine_theme_farend_bleuclair.git \
  public/themes/bleuclair
