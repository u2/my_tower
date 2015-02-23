module PaperTrail
  module Rails
    module Controller
      protected

      def user_for_paper_trail
        return {
          name: current_user.email,
          id: current_user.id
        } if current_user
      end
    end

    class Engine < ::Rails::Engine 
      paths['app/models'] << 'lib/paper_trail/frameworks/active_record/models'
    end
  end

  module Model
    module InstanceMethods
      private

      # save object when create
      def set_object
        if paper_trail_switched_on?
          create_event = self.events.where(event: :create).first
          # 用object_attrs_for_paper_trail(item_before_change) 不行
          # 用self在某些非常特殊的情况下可能会存在bug，暂时未发现问题
          object_attrs = object_attrs_for_paper_trail(self)
          create_event.update_column(:object, self.class.paper_trail_version_class.object_col_is_json? ? object_attrs : PaperTrail.serializer.dump(object_attrs))
        end
      end

      alias :original_merge_metadata :merge_metadata

      def merge_metadata(data)
        if data[:whodunnit]
          data[:whodunnit_id] = data[:whodunnit][:id]
        end

        data[:project_id] = self.project_id
        data[:team_id] = self.team_id
        original_merge_metadata(data)
      end
    end
  end
end

# config/initializers/paper_trail.rb
PaperTrail::Version.module_eval do
  self.abstract_class = true
end

