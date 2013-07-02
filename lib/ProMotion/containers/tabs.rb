module ProMotion
  module Tabs
    attr_accessor :tab_bar, :tab_bar_item
    
    def open_tab_bar(*screens)
      self.tab_bar = PM::TabBarController.new(screens)

      delegate = self.respond_to?(:open_root_screen) ? self : UIApplication.sharedApplication.delegate

      delegate.open_root_screen(self.tab_bar)
      self.tab_bar
    end

    def open_tab(tab)
      self.tab_bar.open_tab(tab)
    end

    def set_tab_bar_item(args = {})
      self.tab_bar_item = args
      refresh_tab_bar_item
    end

    def refresh_tab_bar_item
      self.tabBarItem = create_tab_bar_item(self.tab_bar_item) if self.tab_bar_item && self.respond_to?(:tabBarItem=)
    end

    def set_tab_bar_badge(number)
      self.tab_bar_item[:badge] = number
      refresh_tab_bar_item
    end

    def create_tab_bar_icon(icon, tag)
      return UITabBarItem.alloc.initWithTabBarSystemItem(icon, tag: tag)
    end

    def create_tab_bar_icon_custom(title, image_name, tag)
      icon_image = UIImage.imageNamed(image_name)
      return UITabBarItem.alloc.initWithTitle(title, image:icon_image, tag:tag)
    end

    def create_tab_bar_item(tab={})
      title = "Untitled"
      title = tab[:title] if tab[:title]
      tab[:tag] ||= @current_tag ||= 0
      @current_tag = tab[:tag] + 1

      tab_bar_item = create_tab_bar_icon(tab[:system_icon], tab[:tag]) if tab[:system_icon]
      tab_bar_item = create_tab_bar_icon_custom(title, tab[:icon], tab[:tag]) if tab[:icon]

      tab_bar_item.badgeValue = tab[:badge_number].to_s unless tab[:badge_number].nil? || tab[:badge_number] <= 0

      return tab_bar_item
    end
    
    def replace_current_item(tab_bar_controller, view_controller: vc)
      controllers = NSMutableArray.arrayWithArray(tab_bar_controller.viewControllers)
      controllers.replaceObjectAtIndex(tab_bar_controller.selectedIndex, withObject: vc)
      tab_bar_controller.viewControllers = controllers
    end
  end
end