
define :celery_app do
  celeryd = "celeryd-#{params[:name]}"
  celerybeat = "celerybeat-#{params[:name]}"
  root_dir = params[:root_dir].sub(/\/$/, '')

  template "/etc/default/#{celeryd}" do
    source 'celeryd.conf.erb'
    cookbook "django"
    owner 'root'
    group 'root'
    mode '0700'
    variables ({
      :chdir => root_dir
    })
  end

  template "/etc/init.d/#{celeryd}" do
    source 'celeryd.erb'
    cookbook "django"
    owner 'root'
    group 'root'
    mode '0755'
    variables ({
      :celery_defaults => "/etc/default/#{celeryd}",
    })
  end

  template "/etc/default/#{celerybeat}" do
    source 'celerybeat.conf.erb'
    cookbook "django"
    owner 'root'
    group 'root'
    mode '0700'
    variables ({
      :chdir => root_dir
    })
  end

  template "/etc/init.d/#{celerybeat}" do
    source 'celerybeat.erb'
    cookbook "django"
    owner 'root'
    group 'root'
    mode '0755'
    variables ({
      :celery_defaults => "/etc/default/#{celeryd}",
      :celerybeat_defaults => "/etc/default/#{celerybeat}",
    })
  end

end
