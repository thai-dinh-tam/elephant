module JobsHelper
    require 'axlsx'

    def custom_data_to_excel job
        p = Axlsx::Package.new
        wb = p.workbook

        wb.styles do |s|
            title_cell = s.add_style :bg_color => "FF", :fg_color => "2c5c84", :b => true, :sz => 18, :alignment => {:horizontal => :center}
            title_cell2 = s.add_style :bg_color => "FF", :fg_color => "2c5c84", :b => true, :sz => 14, :alignment => {:horizontal => :center}
            column_name_cell = s.add_style :bg_color => "b9cce4", :fg_color => "2c5c84", :sz => 14, :b => true, :alignment => {:horizontal => :left}, :border => {:style => :thin, :color => "00", :edges => [:top, :bottom]}

            cell1 = s.add_style :bg_color => "dbe6f1", :fg_color => "2c5c84", :b => false, :sz => 13, :alignment => {:horizontal => :left}
            cell2 = s.add_style :bg_color => "b9cce4", :fg_color => "2c5c84", :b => false, :sz => 13, :alignment => {:horizontal => :left}
            cell1_bold = s.add_style :bg_color => "dbe6f1", :fg_color => "2c5c84", :b => true, :sz => 13, :alignment => {:horizontal => :left}
            cell2_bold = s.add_style :bg_color => "b9cce4", :fg_color => "2c5c84", :b => true, :sz => 13, :alignment => {:horizontal => :left}


            margins = {:left => 1, :right => 1, :top => 1, :bottom => 1, :header => 0, :footer => 0}
            setup = {:fit_to_width => 1, :orientation => :portrait, :paper_width => "21cm", :paper_height => "29.7cm"}
            options = {:grid_lines => true, :headings => true, :horizontal_centered => true}

            wb.add_worksheet(:name => "Job Data", :page_margins => margins, :page_setup => setup, :print_options => options) do |sheet|
                row = sheet.add_row ['Job Data', '', '', ''], :style => title_cell
                row = sheet.add_row [job.field.name + " | " + job.well.name, '', '', ''], :style => title_cell2
                sheet.add_row ['', '', '', ''], :style => title_cell
                #sheet.add_row ['Date', 'Time', 'Comment/Description', 'User'], :style => column_name_cell


                sheet.add_row ['Required Data', '', '', ''], :style => column_name_cell
                job.dynamic_fields_required.each_with_index do |field, index|
                    sheet.add_row [field.name, (field.value_type != 1 && !field.value.nil? ? field.value.to_f.round(3).to_s : field.value || '') + " " + (field.get_value_type_unit(field.value_type) || ''), '', ''], :style => index % 2 == 0 ? [cell1_bold, cell1, cell1, cell1] : [cell2_bold, cell2, cell2, cell2]
                end

                sheet.add_row ['', '', '', ''], :style => cell1
                sheet.add_row ['', '', '', ''], :style => cell1

                sheet.add_row ['Optional Data', '', '', ''], :style => column_name_cell
                job.dynamic_fields_optional.each_with_index do |field, index|
                    sheet.add_row [field.name, (field.value_type != 1 && !field.value.nil? ? field.value.to_f.round(3).to_s : field.value || '') + " " + (field.get_value_type_unit(field.value_type) || ''), '', ''], :style => index % 2 == 0 ? [cell1_bold, cell1, cell1, cell1] : [cell2_bold, cell2, cell2, cell2]
                end

                sheet.add_row ['', '', '', ''], :style => cell1
                sheet.add_row ['', '', '', ''], :style => cell1

                sheet.add_row ['Well Data', '', '', ''], :style => column_name_cell
                well_data = Well.accessible_attributes.select { |w| !w.blank? && !Well.human_attribute_name(w).include?("value type") }
                well_data.each_with_index do |field, index|
                    value_type = job.well[(field + "_value_type").to_s]
                    unit_type = ''
                    if value_type.present?
                        unit_type = DynamicField.new.get_value_type_unit(value_type.to_i).to_s
                    end
                    value = job.well[field.to_s]
                    sheet.add_row [Well.human_attribute_name(field), value.to_s + " " + unit_type, '', ''], :style => index % 2 == 0 ? [cell1_bold, cell1, cell1, cell1] : [cell2_bold, cell2, cell2, cell2]
                end

                #entries.each_with_index do |entry, index|
                #    sheet.add_row [entry.entry_at.strftime("%a %m/%d/%Y"), entry.entry_at.strftime("%l:%M %p"), entry.comment, entry.user.present? ? entry.user.name : entry.user_name], :style => index % 2 == 0 ? cell1 : cell2
                #end

                sheet.column_widths 30, 30, 20, 15

                sheet.merge_cells("A1:D1")
                sheet.merge_cells("A2:D2")

            end
        end

        p
    end


    def primary_tools_to_excel job
        p = Axlsx::Package.new
        wb = p.workbook

        wb.styles do |s|
            title_cell = s.add_style :bg_color => "FF", :fg_color => "2c5c84", :b => true, :sz => 18, :alignment => {:horizontal => :center}
            title_cell2 = s.add_style :bg_color => "FF", :fg_color => "2c5c84", :b => true, :sz => 14, :alignment => {:horizontal => :center}
            column_name_cell = s.add_style :bg_color => "b9cce4", :fg_color => "2c5c84", :sz => 14, :b => true, :alignment => {:horizontal => :left}, :border => {:style => :thin, :color => "00", :edges => [:top, :bottom]}

            cell1 = s.add_style :bg_color => "dbe6f1", :fg_color => "2c5c84", :b => false, :sz => 13, :alignment => {:horizontal => :left}
            cell2 = s.add_style :bg_color => "b9cce4", :fg_color => "2c5c84", :b => false, :sz => 13, :alignment => {:horizontal => :left}
            cell1_bold = s.add_style :bg_color => "dbe6f1", :fg_color => "2c5c84", :b => true, :sz => 13, :alignment => {:horizontal => :left}
            cell2_bold = s.add_style :bg_color => "b9cce4", :fg_color => "2c5c84", :b => true, :sz => 13, :alignment => {:horizontal => :left}
            cell1_serial = s.add_style :bg_color => "dbe6f1", :fg_color => "0058a8", :b => true, :sz => 13, :alignment => {:horizontal => :left}
            cell2_serial = s.add_style :bg_color => "b9cce4", :fg_color => "0058a8", :b => true, :sz => 13, :alignment => {:horizontal => :left}


            margins = {:left => 1, :right => 1, :top => 1, :bottom => 1, :header => 0, :footer => 0}
            setup = {:fit_to_width => 1, :orientation => :portrait, :paper_width => "21cm", :paper_height => "29.7cm"}
            options = {:grid_lines => true, :headings => true, :horizontal_centered => true}

            wb.add_worksheet(:name => "Tools-Assets", :page_margins => margins, :page_setup => setup, :print_options => options) do |sheet|
                sheet.add_row ['Tools/Assets', '', '', ''], :style => title_cell
                sheet.add_row [job.field.name + " | " + job.well.name, '', '', ''], :style => title_cell2
                sheet.add_row ['', '', '', ''], :style => title_cell


                job.job_template.primary_tools.where(:template => false).where(:job_id => @job.id).includes(:tool).order("tools.name ASC, primary_tools.created_at ASC").each_with_index do |primary_tool, index|
                    sheet.add_row [primary_tool.tool.name, primary_tool.tool.description, '', ''], :style => index % 2 == 0 ? [cell1_bold, cell1, cell1, cell1] : [cell2_bold, cell2, cell2, cell2]

                    if primary_tool.simple_tracking
                        sheet.add_row ['', 'Serial # ' + primary_tool.serial_number, '', primary_tool.received? ? "Received" : ""], :style => index % 2 == 0 ? [cell1_bold, cell1, cell1_serial, cell1] : [cell2_bold, cell2, cell2_serial, cell2]
                    else
                        primary_tool.part_memberships.where(:template => true).each_with_index do |p, index2|
                            part_membership = p.usage_part_membership(job.id)
                            if part_membership.present? && part_membership.part.present?
                                sheet.add_row ['', 'Material # ' + p.material_number, 'Serial # ' + (part_membership.part.serial_number || ""), ''], :style => index % 2 == 0 ? [cell1_bold, cell1, cell1_serial, cell1] : [cell2_bold, cell2, cell2_serial, cell2]
                            else
                                sheet.add_row ['', 'Material # ' + p.material_number, '', ''], :style => index % 2 == 0 ? [cell1_bold, cell1, cell1, cell1] : [cell2_bold, cell2, cell2, cell2]
                            end
                        end
                        if !primary_tool.comments.blank?
                            sheet.add_row ['', 'Comments: ' + (primary_tool.comments || ""), '', ''], :style => index % 2 == 0 ? [cell1_bold, cell1, cell1, cell1] : [cell2_bold, cell2, cell2, cell2]
                        end
                    end
                end

                sheet.add_row ['', '', '', ''], :style => title_cell
                sheet.add_row ['', '', '', ''], :style => title_cell
                sheet.add_row ['', '', '', ''], :style => title_cell

                if job.secondary_tools.any?
                    sheet.add_row ['Accessories', '', '', ''], :style => title_cell2
                    job.secondary_tools.where(:job_id => @job.id).includes(:tool).order("tools.name ASC, secondary_tools.created_at ASC").each_with_index do |secondary_tool, index|
                        sheet.add_row [secondary_tool.tool.name, secondary_tool.tool.description, '', ''], :style => index % 2 == 0 ? [cell1_bold, cell1, cell1, cell1] : [cell2_bold, cell2, cell2, cell2]

                        if job.job_template.track_accessories
                            sheet.add_row ['', 'Serial # ' + secondary_tool.serial_number, '', secondary_tool.received? ? "Received" : ""], :style => index % 2 == 0 ? [cell1_bold, cell1, cell1_serial, cell1] : [cell2_bold, cell2, cell2_serial, cell2]
                        end
                    end
                end

                sheet.column_widths 25, 50, 20, 5

                sheet.merge_cells("A1:D1")
                sheet.merge_cells("A2:D2")

            end
        end

        p
    end
end
