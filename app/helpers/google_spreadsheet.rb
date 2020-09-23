require 'google/apis/drive_v3'
require 'google/apis/sheets_v4'
require 'googleauth'

module GoogleSpreadsheet
	GSheets = Google::Apis::SheetsV4
	def login()
		# Get the environment configured authorization
		scopes =  ['https://www.googleapis.com/auth/drive', GSheets::AUTH_SPREADSHEETS, Google::Apis::DriveV3::AUTH_DRIVE]
		authorization = Google::Auth::ServiceAccountCredentials.make_creds(scope: scopes)
	end

	def new_sheet(title, auth = nil)
		sheets = get_sheet_service(auth)

		sheet = GSheets::Spreadsheet.new
		sheet.properties = GSheets::SpreadsheetProperties.new(title: title)
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
		value_range = GSheets::ValueRange.new(range: range, values: data)
		get_sheet_service(auth).update_spreadsheet_value(sheet.spreadsheet_id,
                                          range,
                                          value_range,
                                          value_input_option: 'USER_ENTERED')
	end

	def get_data(sheet, range, auth = nil)
		get_sheet_service(auth).get_spreadsheet_values(sheet.spreadsheet_id, range)
	end

	def batch_update(sheet, requests, auth = nil)
		batch = GSheets::BatchUpdateSpreadsheetRequest.new(requests: requests)
		get_sheet_service(auth).batch_update_spreadsheet(sheet.spreadsheet_id, batch)
	end

	def create_list_validation_request(start_row_index, end_row_index, start_column_index, end_column_index, values)
		condition = GSheets::BooleanCondition.new(type: 'ONE_OF_LIST', values: values.map{|v| GSheets::ConditionValue.new(user_entered_value: v)})
		rule = GSheets::DataValidationRule.new(condition: condition, strict: true, show_custom_ui: true)
		create_validation_request(start_row_index, end_row_index, start_column_index, end_column_index, rule)
	end

	def create_validation_request(start_row_index, end_row_index, start_column_index, end_column_index, rule)
		grid_range = create_grid_range(start_row_index, end_row_index, start_column_index, end_column_index)
		data_validation_request = GSheets::SetDataValidationRequest.new(range: grid_range, rule: rule)
		GSheets::Request.new(set_data_validation: data_validation_request)
	end

	def create_hide_column_request(column)
		hide_column_request = GSheets::UpdateDimensionPropertiesRequest.new
		hide_column_request.properties = GSheets::DimensionProperties.new(hidden_by_user: true)
		hide_column_request.range = GSheets::DimensionRange.new(sheet_id: 0,
      dimension: 'COLUMNS',
      start_index: column-1,
      end_index: column)
		hide_column_request.fields = 'hiddenByUser'
		GSheets::Request.new(update_dimension_properties: hide_column_request)
	end

	def create_color_rows_request(start_row_index, end_row_index, start_column_index, end_column_index, red, green, blue, alpha)
		repeat_cell_request = GSheets::RepeatCellRequest.new
		color = GSheets::Color.new(red: red, green: green, blue: blue, alpha: alpha)
		fmt = GSheets::CellFormat.new(background_color: color)
		repeat_cell_request.cell = GSheets::CellData.new(user_entered_format: fmt)
		repeat_cell_request.range = create_grid_range(start_row_index, end_row_index, start_column_index, end_column_index)
		repeat_cell_request.fields = 'userEnteredFormat(backgroundColor)'
		GSheets::Request.new(repeat_cell: repeat_cell_request)
	end

	def create_protect_rows_request(start_row_index, end_row_index, start_column_index, end_column_index)
    grid_range = create_grid_range(start_row_index, end_row_index, start_column_index, end_column_index)
		editors = GSheets::Editors.new(users:["webservice@my-home-library-194020.iam.gserviceaccount.com"])
		protected_range = GSheets::ProtectedRange.new(range: grid_range, editors:editors )
		protected_range_request = GSheets::AddProtectedRangeRequest.new(protected_range: protected_range)
		GSheets::Request.new(add_protected_range: protected_range_request)
  end


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
	def create_grid_range(start_row_index, end_row_index, start_column_index, end_column_index)
		GSheets::GridRange.new(sheet_id: 0,
            start_row_index: start_row_index,
            end_row_index: end_row_index+1,
            start_column_index: start_column_index,
            end_column_index: end_column_index)
	end

	def get_drive_service(auth = nil)
		drive = Google::Apis::DriveV3::DriveService.new
    drive.authorization = auth || login()
		drive
	end

	def get_sheet_service(auth = nil)
		sheets = GSheets::SheetsService.new
    sheets.authorization = auth || login()
		sheets
	end
end
