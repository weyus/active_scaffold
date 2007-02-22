module ActiveScaffold::Actions
  module Delete
    include Base

    # this method is for html mode. it provides "the missing action" (http://thelucid.com/articles/2006/07/26/simply-restful-the-missing-action).
    # it also gives us delete confirmation for html mode. woo!
    def delete
      insulate { do_delete }
      render :action => 'delete'
    end

    def destroy
      return redirect_to(params.merge(:action => :delete)) if request.get?

      insulate { do_destroy }

      @successful = successful?
      respond_to do |type|
        type.html do
          flash[:info] = _('DELETED %s', @record.to_label)
          return_to_main
        end
        type.js { render(:action => 'destroy.rjs', :layout => false) }
        type.xml { render :xml => @successful ? "" : response_object.to_xml, :content_type => Mime::XML, :status => response_status }
        type.json { render :text => @successful ? "" : response_object.to_json, :content_type => Mime::JSON, :status => response_status }
        type.yaml { render :text => @successful ? "" : response_object.to_yaml, :content_type => Mime::YAML, :status => response_status }
      end
    end

    protected

    def do_delete
      @record = find_if_allowed(params[:id], 'delete')
    end

    def do_destroy
      @record = find_if_allowed(params[:id], 'delete')
      @record.destroy
    end
  end
end