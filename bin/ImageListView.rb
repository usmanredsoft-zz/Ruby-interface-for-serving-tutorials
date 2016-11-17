

class ImageListView < VR::ListView


	AUDIO_ICON = Gdk::Pixbuf.new(File.dirname(__FILE__) + "/png.png")

	@@sel = 0
	@@num = 0
	@@arrayChildFolders = Array.new()

	def initialize


		@arrayChildFolders = Array.new()

		@cols = {}
		@cols["Image"] = {:pix => Gdk::Pixbuf, :song => String }

		super(@cols)

		col_sort_column_id( :song => id(:song))

	end

	def refresh()
		data = get_data()
		len = data.length
		if len == 0
			return
		end
		(0..len-1).each do |i|
				row = add_row()
	  			row[:pix] = AUDIO_ICON
				row[:song] = data[i]
		end
	end

	def get_data
		rows = []
		rows = @@arrayChildFolders
	end

	def set_data(folders)
		@@arrayChildFolders = folders
		@@count = @@arrayChildFolders.length - 1
		refresh()
		select_row(0)
	end

	def setSelRow(row)
		@@sel= row
	end

	def move(direction)

		temp = String.new("dfs")
		sell = String.new(@@sel)
		nextsell = 0
		count = 0
		(0..@@count).each do |i|
			count = count +1
		end
		#VR::msg count.to_s
		case direction
			when 1     #top
				begin
					temp = @@arrayChildFolders[sell.to_i]
					@@arrayChildFolders[sell.to_i] = @@arrayChildFolders[0]
					@@arrayChildFolders[0] = temp
					nextsell = 0
					model.clear
					refresh()
					select_row(nextsell)
				end
			when 2     #up
			  if sell.to_i > 0
				  temp = @@arrayChildFolders[sell.to_i]
				  @@arrayChildFolders[sell.to_i] = @@arrayChildFolders[sell.to_i-1]
				  @@arrayChildFolders[sell.to_i-1] = temp
				  nextsell = sell.to_i-1
					model.clear
					refresh()
					select_row(nextsell)
			  end
			when 3     #down
			  if sell.to_i < count-1
				  temp = @@arrayChildFolders[sell.to_i]
				  @@arrayChildFolders[sell.to_i] = @@arrayChildFolders[sell.to_i+1]
				  @@arrayChildFolders[sell.to_i+1] = temp
				  nextsell = sell.to_i+1
					model.clear
					refresh()
					select_row(nextsell)
			  end
			when 4     #bottom
			  begin
			    temp = @@arrayChildFolders[sell.to_i]
			    @@arrayChildFolders[sell.to_i] = @@arrayChildFolders[count-1]
			    @@arrayChildFolders[count-1] = temp
				 	nextsell = count - 1
					model.clear
					refresh()
					select_row(nextsell)
			  end

		end

	end


end
