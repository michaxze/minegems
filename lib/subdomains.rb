module Subdomains
  private
    def require_no_subdomain
      if request.env['MINEGEMS_SITE']
        redirect_to request.url.gsub(/#{request.env['MINEGEMS_SITE']['tld']}\./, "")
      end
    end

    def ensure_site
      if ( @site = request.env['MINEGEMS_SITE'] ).blank?
        redirect_to root_url # TODO application_root_url
      end
    end

    def ensure_site_access
      unless Minegems::Rack::SubdomainRouter.access_granted?(@site, current_user)
        redirect_to root_url # TODO application_root_url
      end
    end

    def load_site
      @site = ::Subdomain.by_tld(@site['tld']).first
    end

    def set_site!
      ensure_site
      ensure_site_access
      load_site
    end
end