require 'google/apis/drive_v3'
require 'google/apis/sheets_v4'
require 'googleauth'

module GoogleSpreadsheet

	def login()
		# Get the environment configured authorization
		scopes =  ['https://www.googleapis.com/auth/drive', Google::Apis::SheetsV4::AUTH_SPREADSHEETS, Google::Apis::DriveV3::AUTH_DRIVE]
		authorization = Google::Auth.get_application_default(scopes)
	end

	def new_sheet(title, auth = nil)
		sheets = get_sheet_service(auth)

		sheet = Google::Apis::SheetsV4::Spreadsheet.new
		sheet.properties = Google::Apis::SheetsV4::SpreadsheetProperties.new(title: title)
		sheet = sheets.create_spreadsheet(sheet)
		share(sheet.spreadsheet_id, auth)
		sheet
	end

	def get_sheet(id = nil, title = nil, auth = nil)
		unless id.nil?
			return get_sheet_service(auth).get_spreadsheet(id)
		end
		files = list(auth, name.nil? ? nil : "name='#{title}'")
		if files.size == 1
			return get_sheet_service(auth).get_spreadsheet(files[0].id)
		elsif files.size > 1
			raise "More than 1 file found with name #{title}"
		else
			nil
		end
	end

	def add_data(sheet, range, data, auth = nil)
		value_range = Google::Apis::SheetsV4::ValueRange.new(range: range, values: data)
		get_sheet_service(auth).update_spreadsheet_value(sheet.spreadsheet_id,
                                          range,
                                          value_range,
                                          value_input_option: 'USER_ENTERED')
	end

	def get_data(sheet, range, auth = nil)
		get_sheet_service(auth).get_spreadsheet_values(sheet.spreadsheet_id, range)
	end

	def hide_column(sheet, column, auth = nil)
		hide_column_request = Google::Apis::SheetsV4::UpdateDimensionPropertiesRequest.new
		hide_column_request.properties = Google::Apis::SheetsV4::DimensionProperties.new(hidden_by_user: true)
		hide_column_request.range = Google::Apis::SheetsV4::DimensionRange.new(sheet_id: 0,
      dimension: 'COLUMNS',
      start_index: column-1,
      end_index: column)
		hide_column_request.fields = 'hiddenByUser'
		r = Google::Apis::SheetsV4::Request.new(update_dimension_properties: hide_column_request)
		requests = Google::Apis::SheetsV4::BatchUpdateSpreadsheetRequest.new(requests: [r])
		get_sheet_service(auth).batch_update_spreadsheet(sheet.spreadsheet_id, requests)
	end

	def color_rows(sheet, start_row_index, end_row_index, start_column_index, end_column_index, red, green, blue, alpha, auth = nil)
		repeat_cell_request = Google::Apis::SheetsV4::RepeatCellRequest.new
		color = Google::Apis::SheetsV4::Color.new(red: red, green: green, blue: blue, alpha: alpha)
		fmt = Google::Apis::SheetsV4::CellFormat.new(background_color: color)
		repeat_cell_request.cell = Google::Apis::SheetsV4::CellData.new(user_entered_format: fmt)
		repeat_cell_request.range = Google::Apis::SheetsV4::GridRange.new(sheet_id: 0,
			start_row_index: start_row_index,
			end_row_index: end_row_index+1,
			start_column_index: start_column_index,
			end_column_index: end_column_index)
		repeat_cell_request.fields = 'userEnteredFormat(backgroundColor)'
		r = Google::Apis::SheetsV4::Request.new(repeat_cell: repeat_cell_request)
		requests = Google::Apis::SheetsV4::BatchUpdateSpreadsheetRequest.new(requests: [r])
		get_sheet_service(auth).batch_update_spreadsheet(sheet.spreadsheet_id, requests)
	end

	# def add_value_list(sheet, column_index, start_column_index, end_column_index, red, green, blue, alpha, auth = nil)
	# 	repeat_cell_request = Google::Apis::SheetsV4::RepeatCellRequest.new
	# 	color = Google::Apis::SheetsV4::Color.new(red: red, green: green, blue: blue, alpha: alpha)
	# 	fmt = Google::Apis::SheetsV4::CellFormat.new(background_color: color)
	# 	repeat_cell_request.cell = Google::Apis::SheetsV4::CellData.new(user_entered_format: fmt)
	# 	repeat_cell_request.range = Google::Apis::SheetsV4::GridRange.new(sheet_id: 0,
	# 		start_row_index: row_index,
	# 		end_row_index: row_index+1,
	# 		start_column_index: start_column_index,
	# 		end_column_index: end_column_index)
	# 	repeat_cell_request.fields = 'userEnteredFormat(backgroundColor)'
	# 	r = Google::Apis::SheetsV4::Request.new(repeat_cell: repeat_cell_request)
	# 	requests = Google::Apis::SheetsV4::BatchUpdateSpreadsheetRequest.new(requests: [r])
	# 	get_sheet_service(auth).batch_update_spreadsheet(sheet.spreadsheet_id, requests)
	# end

	def list(auth = nil, query = nil)
    drive = get_drive_service(auth)

		rv = []
    page_token = nil
    limit = 1000
    begin
      result = drive.list_files(q: query,
                                page_size: [limit, 100].min,
                                page_token: page_token,
                                fields: 'files(id,name),next_page_token')

      result.files.each { |file| rv << file }
      limit -= result.files.length
      if result.next_page_token
        page_token = result.next_page_token
      else
        page_token = nil
      end
    end while !page_token.nil? && limit > 0
		rv
  end

	def share(file_id, auth = nil)
		drive = get_drive_service(auth)
		permission = Google::Apis::DriveV3::Permission.new(allow_file_discovery: false, role: 'writer', type: 'anyone')
		drive.create_permission(file_id, permission)
	end

	def delete(file_id, auth = nil)
		drive = get_drive_service(auth)
		drive.delete_file(file_id)
	end
private
	def get_drive_service(auth = nil)
		drive = Google::Apis::DriveV3::DriveService.new
    drive.authorization = auth || login()
		drive
	end

	def get_sheet_service(auth = nil)
		sheets = Google::Apis::SheetsV4::SheetsService.new
    sheets.authorization = auth || login()
		sheets
	end
end
