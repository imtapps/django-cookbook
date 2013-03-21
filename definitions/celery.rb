define :celery_app do
  celeryd = "celeryd-#{params[:name]}"
  celerybeat = "celerybeat-#{params[:name]}"
  newrelic = params[:newrelic]
  virtualenv_path = params[:virtualenv_path].sub(/\/$/, '')
  managepy_path = params[:managepy_path].sub(/\/$/, '')

  template "/etc/default/#{celeryd}" do
    source 'celeryd.conf.erb'
    cookbook "django"
    owner 'root'
    group 'root'
    mode '0700'
    variables ({
      :virtualenv_path => virtualenv_path,
      :managepy_path => managepy_path
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
      :celeryd_name => celeryd
    })
  end

  if params[:celerybeat]
    template "/etc/default/#{celerybeat}" do
      source 'celerybeat.conf.erb'
      cookbook "django"
      owner 'root'
      group 'root'
      mode '0700'
      variables ({
        :virtualenv_path => virtualenv_path,
        :managepy_path => managepy_path
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
        :celeryd_name => celeryd,
        :celerybeat_name => celerybeat
      })
    end
  end
end
