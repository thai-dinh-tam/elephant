class Crew < ActiveRecord::Base
    attr_accessible :name,
                    :crew_memberships_count

    acts_as_tenant(:company)

    validates :name, presence: true, length: {maximum: 100}
    validates_uniqueness_of :name, :case_sensitive => false, scope: :district_id
    validates :company, presence: true
    validates :district, presence: true

    belongs_to :company
    belongs_to :district
    belongs_to :current_job, :class_name => "Job"

end
