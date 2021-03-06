# == Schema Information
#
# Table name: public_body_category_link
#
#  public_body_category_id       :integer        not null
#  public_body_heading_id        :integer        not null
#  category_display_order        :integer
#

require 'spec_helper'

describe PublicBodyHeading, 'when validating' do

    it 'should set a default display order based on the next available display order' do
        heading = FactoryGirl.create(:public_body_heading)
        category = FactoryGirl.create(:public_body_category)
        category_link = PublicBodyCategoryLink.new(:public_body_heading => heading,
                                                   :public_body_category => category)
        category_link.valid?
        category_link.category_display_order.should == PublicBodyCategoryLink.next_display_order(heading)
    end

    it 'should be invalid without a category' do
        category_link = PublicBodyCategoryLink.new
        category_link.should_not be_valid
        category_link.errors[:public_body_category].should == ["can't be blank"]
    end

    it 'should be invalid without a heading' do
        category_link = PublicBodyCategoryLink.new
        category_link.should_not be_valid
        category_link.errors[:public_body_heading].should == ["can't be blank"]
    end

end

describe PublicBodyCategoryLink, 'when setting a category display order' do

    it 'should return 0 if there are no public body headings' do
        heading = FactoryGirl.create(:public_body_heading)
        PublicBodyCategoryLink.next_display_order(heading).should == 0
    end

    it 'should return one more than the highest display order if there are public body headings' do
        heading = FactoryGirl.create(:public_body_heading)
        category = FactoryGirl.create(:public_body_category)
        category_link = PublicBodyCategoryLink.create(:public_body_heading_id => heading.id,
                                                      :public_body_category_id => category.id)

        PublicBodyCategoryLink.next_display_order(heading).should == 1
    end

end
