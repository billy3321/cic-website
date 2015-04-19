class RenameAttendCountToAttendance < ActiveRecord::Migration
  def change
    rename_column :ccw_committee_data, :should_attend_count, :should_attendance
    rename_column :ccw_committee_data, :actually_average_attend_count, :actually_average_attendance
    rename_column :ccw_legislator_data, :ys_attend_count, :yc_attendance
    rename_column :ccw_legislator_data, :sc_attend_count, :sc_attendance
  end
end
