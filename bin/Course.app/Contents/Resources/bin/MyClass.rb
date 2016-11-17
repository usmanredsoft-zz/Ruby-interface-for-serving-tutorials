require 'JSON'
require 'pp'

class MyClass

	include GladeGUI

	@strRoot = String.new("root")
	@strCourse = String.new("course")
	@strFinalPath = String.new("course")

	@strRoot_util = String.new("root")
	@strCourse_util = String.new("course")
	@strFinalPath_util = String.new("course")
	

	@arrImageCB = Array.new()
	@curImageCB = 0

	@arrImageUtil = Array.new()
	@curImageUtil = 0


	@arrCourse = Array.new()

	@nStep = 0
	@nLesson = 0

  def before_show()

		#load_glade(__FILE__)

		@fileChoosercb = @builder["btn_filechooser_cb"]

		@fileChoosercb.current_folder = "/Users/macmini/Desktop/myCourses"

		@courseview = SongListView.new()

		@builder["scroll_course_cb"].add(@courseview)

		@courseview.selection.signal_connect("changed") { course_view__changed }

		

		@lessonview = SongListView.new()

		@builder["scroll_lesson_cb"].add(@lessonview)

		@lessonview.selection.signal_connect("changed") { lesson_view__changed }



		@fileChooserutil = @builder["btn_filechooser_util"]

		@fileChooserutil.current_folder = "/Users/macmini/Desktop/myCourses"

		@courseviewutil = SongListView.new()

		@builder["scroll_course_util"].add(@courseviewutil)

		@courseviewutil.selection.signal_connect("changed") { util_course_view__changed }

		

		@lessonviewutil = SongListView.new()

		@builder["scroll_lesson_util"].add(@lessonviewutil)

		@lessonviewutil.selection.signal_connect("changed") { util_lesson_view__changed }


		@lessonstack = SongListView.new()

		@builder["scroll_lstack_cb"].add(@lessonstack)

		@lessonstack.selection.signal_connect("changed") { lesson_stack__changed }



		@lessonstackutil = SongListView.new()

		@builder["scroll_lstack_util"].add(@lessonstackutil)

		@lessonstackutil.selection.signal_connect("changed") { util_lesson_stack__changed }

		
		@spin_step_ci = 1
		@spin_step_util = 1

	end	


	def on_btn_filechooser_cb_current_folder_changed()


		@strRoot = @fileChoosercb.current_folder

		pathd = Dir[@strRoot + "/*"]

		if @courseview != nil

			@courseview.model.clear

			@courseview.set_data(pathd)

		end

	end

	def on_btn_filechooser_util_current_folder_changed()


		@strRoot_util = @fileChooserutil.current_folder

		pathd = Dir[@strRoot_util + "/*"]

		if @courseviewutil != nil

			@courseviewutil.model.clear

			@courseviewutil.set_data(pathd)

		end


	end

	def course_view__changed








		return unless row = @courseview.selected_rows[0]

		@strCourse = row[:song]

		pathd = Dir[@strRoot + "/" + @strCourse +"/*"]

		@arrCourse = Array.new(pathd.size)

		(0..pathd.size-1).each do |i|
			if pathd[i].count(".")== 0
				#VR::msg pathd[i] + "/" + "content.json"
				json = File.read(pathd[i] + "/" + "content.json")
				obj = JSON.parse(json)
				@arrCourse[i] = obj
			end
		end



		if @lessonview != nil

			@lessonview.model.clear

			@lessonview.set_data(pathd)

		end







	end

	def lesson_view__changed

		return unless row = @lessonview.selected_rows[0]
		
		@strFinalPath = @strRoot + "/" + @strCourse +"/" + row[:song]

		json = File.read(@strFinalPath + "/" + "content.json")

		obj = JSON.parse(json)
		
		steps = obj["step"]


#Lesson Stack Browser

		stepname = Array.new(steps.size)		

		(0..steps.size-1).each do |i|
			stepname[i] = steps[i]["Name"]
		end	

		if @lessonstack != nil

			@lessonstack.model.clear

			@lessonstack.set_data(stepname)

		end
#Image Stack Browser


		imagename = Array.new(steps.size)

		(0..steps.size-1).each do |j|
			imagename[j] = steps[j]["Image"]
		end

		@arrImageCB = imagename

		@curImageCB = 0
		@builder["image_cb"].file = @arrImageCB[@curImageCB]
		@builder["spin_image_cb"].value = steps.size
		@builder["imPath_cb"].label = "Image Stack Browser\n\n" + @arrImageCB[@curImageCB].split("/")[ @arrImageCB[@curImageCB].split("/").size-1]




# Current Lesson Tab update

		#VR::msg @arrCourse[0]["step"].size.to_s
		strTemp = String.new(row)

		@nLesson = strTemp.to_i

		@builder["txt_course_cl"].text = @arrCourse[@nLesson]["Course"]
		@builder["txt_lesson_cl"].text = @arrCourse[@nLesson]["Lesson"]


		

		@nStep = 3
		@builder["txt_level_cl"].text = @arrCourse[@nLesson]["step"][@nStep]["Top Level Description"]
		@builder["txt_instruction_cl"].text = @arrCourse[@nLesson]["step"][@nStep]["Instruction"]
		@builder["txt_notes_cl"].text = @arrCourse[@nLesson]["step"][@nStep]["Notes"]
		@builder["img_stepn"].file = @arrCourse[@nLesson]["step"][@nStep]["Image"]
		@builder["imPath_cl"].label = "Image Correspoding to Step(n)" + "\n\n" + @arrCourse[@nLesson]["step"][@nStep]["Image"].split("/")[@arrCourse[@nLesson]["step"][@nStep]["Image"].split("/").size-1]

		(0..@arrCourse[@nLesson]["step"].size-1).each do |i|

		  if i  <	 7

		    @builder["txt_cl_" + i.to_s ].text = @arrCourse[@nLesson]["step"][i]["Name"]

		  end
		end


		@builder["spin_step_ci"].value = @nStep + 1






	end


	def util_course_view__changed

		return unless row = @courseviewutil.selected_rows[0]

		@strCourse_util = row[:song]

		pathd = Dir[@strRoot_util + "/" + @strCourse_util +"/*"]

		if @lessonviewutil != nil

			@lessonviewutil.model.clear

			@lessonviewutil.set_data(pathd)

		end



	end

	def util_lesson_view__changed

		return unless row = @lessonviewutil.selected_rows[0]

		@strFinalPath_util = @strRoot_util + "/" + @strCourse_util +"/" + row[:song]
		
		json = File.read(@strFinalPath_util + "/" + "content.json")

		obj = JSON.parse(json)
		
		steps = obj["step"]


#Lesson Stack Browser util

		stepname = Array.new(steps.size)		

		(0..steps.size-1).each do |i|
			stepname[i] = steps[i]["Name"]
		end	

		if @lessonstackutil != nil

			@lessonstackutil.model.clear

			@lessonstackutil.set_data(stepname)

		end
#Image Stack Browser util

		imagename = Array.new(steps.size)

		(0..steps.size-1).each do |j|
			imagename[j] = steps[j]["Image"]
		end

		@arrImageUtil = imagename

		@curImageUtil = 0
		@builder["image_util"].file = @arrImageUtil[@curImageUtil]
		@builder["spin_image_util"].value = steps.size

		@builder["imPath_util"].label = "Image Stack Browser 2\n\n" + @arrImageUtil[@curImageUtil].split("/")[ @arrImageUtil[@curImageUtil].split("/").size-1]

	end

	def lesson_stack__changed

		return unless row = @lessonstack.selected_rows[0]
		@lessonstack.setSelRow(row)

		strTemp = String.new(row)

		@builder["spin_step_cb"].value = strTemp.to_i + 1

		#@spin_image_cb = 1
		#@spin_step_ci = 1
		#@spin_step_util = 1
		#@spin_image_util = 1

	end

	def image_stack_view__changed

		return unless row = @imagestackview.selected_rows[0]
		@imagestackview.setSelRow(row)

	end

	def util_lesson_stack__changed

		return unless row = @lessonstackutil.selected_rows[0]
		@lessonstackutil.setSelRow(row)

	end

	def util_image_stack_view__changed

		return unless row = @imagestackviewutil.selected_rows[0]
		@imagestackviewutil.setSelRow(row)

	end



	def btn_begin_cb__clicked(button)

	end
	def btn_asso_util__clicked(button)
		VR::msg "asso"
	end


#Lesson Stack Browser 
	def btn_toplsb_cb__clicked(button)
		@lessonstack.move(1)
	end
	def btn_uplsb_cb__clicked(button)
		@lessonstack.move(2)
	end
	def btn_downlsb_cb__clicked(button)
		@lessonstack.move(3)
	end
	def btn_bottomlsb_cb__clicked(button)
		@lessonstack.move(4)
	end
#Image Stack Browser 
	def btn_topisb_cb__clicked(button)

		@builder["image_cb"].file = @arrImageCB[0]
		@curImageCB = 0
		@builder["spin_image_cb"].value = @curImageCB + 1
		@builder["imPath_cb"].label = "Image Stack Browser\n\n" + @arrImageCB[@curImageCB].split("/")[ @arrImageCB[@curImageCB].split("/").size-1]



	end
	def btn_upisb_cb__clicked(button)
		if @curImageCB > 0
			@builder["image_cb"].file = @arrImageCB[@curImageCB - 1]
			@curImageCB = @curImageCB - 1
			@builder["spin_image_cb"].value = @curImageCB + 1
			@builder["imPath_cb"].label = "Image Stack Browser\n\n" + @arrImageCB[@curImageCB].split("/")[ @arrImageCB[@curImageCB].split("/").size-1]
		end
	end
	def btn_downisb_cb__clicked(button)
		if @curImageCB < @arrImageCB.size - 1
			@builder["image_cb"].file = @arrImageCB[@curImageCB + 1]
			@curImageCB = @curImageCB + 1
			@builder["spin_image_cb"].value = @curImageCB + 1
			@builder["imPath_cb"].label = "Image Stack Browser\n\n" + @arrImageCB[@curImageCB].split("/")[ @arrImageCB[@curImageCB].split("/").size-1]
		end
	end
	def btn_bottomisb_cb__clicked(button)
		@builder["image_cb"].file = @arrImageCB[@arrImageCB.size - 1]
		@curImageCB = @arrImageCB.size - 1
		@builder["spin_image_cb"].value = @arrImageCB.size
		@builder["imPath_cb"].label = "Image Stack Browser\n\n" + @arrImageCB[@curImageCB].split("/")[ @arrImageCB[@curImageCB].split("/").size-1]
	end

#Lesson Stack Browser  utility
	def btn_toplsb_util__clicked(button)
		@lessonstackutil.move(1)
	end
	def btn_uplsb_util__clicked(button)
		@lessonstackutil.move(2)
	end
	def btn_downlsb_util__clicked(button)
		@lessonstackutil.move(3)
	end
	def btn_bottomlsb_util__clicked(button)
		@lessonstackutil.move(4)
	end
#Image Stack Browser  utility
	def btn_topisb_util__clicked(button)
		@builder["image_util"].file = @arrImageUtil[0]
		@curImageUtil = 0
		@builder["spin_image_util"].value = @curImageUtil + 1
		@builder["imPath_util"].label = "Image Stack Browser 2\n\n" + @arrImageUtil[@curImageUtil].split("/")[ @arrImageUtil[@curImageUtil].split("/").size-1]
	end
	def btn_upisb_util__clicked(button)
		if @curImageUtil > 0
			@builder["image_util"].file = @arrImageUtil[@curImageUtil - 1]
			@curImageUtil = @curImageUtil - 1
			@builder["spin_image_util"].value = @curImageUtil + 1
			@builder["imPath_util"].label = "Image Stack Browser 2\n\n" + @arrImageUtil[@curImageUtil].split("/")[ @arrImageUtil[@curImageUtil].split("/").size-1]
		end
	end
	def btn_downisb_util__clicked(button)
		if @curImageUtil < @arrImageUtil.size - 1
			@builder["image_util"].file = @arrImageUtil[@curImageUtil + 1]
			@curImageUtil = @curImageUtil + 1
			@builder["spin_image_util"].value = @curImageUtil + 1
			@builder["imPath_util"].label = "Image Stack Browser 2\n\n" + @arrImageUtil[@curImageUtil].split("/")[ @arrImageUtil[@curImageUtil].split("/").size-1]
		end
	end
	def btn_bottomisb_util__clicked(button)
		@builder["image_util"].file = @arrImageUtil[@arrImageUtil.size - 1]
		@curImageUtil = @arrImageUtil.size - 1
		@builder["spin_image_util"].value = @arrImageUtil.size
		@builder["imPath_util"].label = "Image Stack Browser 2\n\n" + @arrImageUtil[@curImageUtil].split("/")[ @arrImageUtil[@curImageUtil].split("/").size-1]
	end
#current lesson
	def btn_top_cl__clicked(button)

		#VR::msg @arrCourse[0]["step"].size.to_s

		@builder["txt_course_cl"].text = @arrCourse[@nLesson]["Course"]
		@builder["txt_lesson_cl"].text = @arrCourse[@nLesson]["Lesson"]

		@nStep = 0
		

		@builder["txt_level_cl"].text = @arrCourse[@nLesson]["step"][@nStep]["Top Level Description"]
		@builder["txt_instruction_cl"].text = @arrCourse[@nLesson]["step"][@nStep]["Instruction"]
		@builder["txt_notes_cl"].text = @arrCourse[@nLesson]["step"][@nStep]["Notes"]
		@builder["img_stepn"].file = @arrCourse[@nLesson]["step"][@nStep]["Image"]
		@builder["imPath_cl"].label = "Image Correspoding to Step(n)" + "\n\n" + @arrCourse[@nLesson]["step"][@nStep]["Image"].split("/")[@arrCourse[@nLesson]["step"][@nStep]["Image"].split("/").size-1]

		@builder["spin_step_ci"].value = @nStep + 1
	end

	def btn_up_cl__clicked(button)
		
		@builder["txt_course_cl"].text = @arrCourse[@nLesson]["Course"]
		@builder["txt_lesson_cl"].text = @arrCourse[@nLesson]["Lesson"]


		if  @nStep > 0



			@nStep = @nStep - 1

			@builder["txt_level_cl"].text = @arrCourse[@nLesson]["step"][@nStep]["Top Level Description"]
			@builder["txt_instruction_cl"].text = @arrCourse[@nLesson]["step"][@nStep]["Instruction"]
			@builder["txt_notes_cl"].text = @arrCourse[@nLesson]["step"][@nStep]["Notes"]
			@builder["img_stepn"].file = @arrCourse[@nLesson]["step"][@nStep]["Image"]
			@builder["imPath_cl"].label = "Image Correspoding to Step(n)" + "\n\n" + @arrCourse[@nLesson]["step"][@nStep]["Image"].split("/")[@arrCourse[@nLesson]["step"][@nStep]["Image"].split("/").size-1]

			@builder["spin_step_ci"].value = @nStep + 1

		end

		if @nStep <= 0
			if @nLesson > 0
			
				@nLesson = @nLesson - 1
				load_current()
			end			
		end


	end

	def btn_down_cl__clicked(button)



		@builder["txt_course_cl"].text = @arrCourse[@nLesson]["Course"]
		@builder["txt_lesson_cl"].text = @arrCourse[@nLesson]["Lesson"]


		if  @nStep < @arrCourse[@nLesson]["Steps"].to_i - 1



			@nStep = @nStep + 1

			@builder["txt_level_cl"].text = @arrCourse[@nLesson]["step"][@nStep]["Top Level Description"]
			@builder["txt_instruction_cl"].text = @arrCourse[@nLesson]["step"][@nStep]["Instruction"]
			@builder["txt_notes_cl"].text = @arrCourse[@nLesson]["step"][@nStep]["Notes"]
			@builder["img_stepn"].file = @arrCourse[@nLesson]["step"][@nStep]["Image"]
			@builder["imPath_cl"].label = "Image Correspoding to Step(n)" + "\n\n" + @arrCourse[@nLesson]["step"][@nStep]["Image"].split("/")[@arrCourse[@nLesson]["step"][@nStep]["Image"].split("/").size-1]

			@builder["spin_step_ci"].value = @nStep + 1

		end

		if @nStep >= @arrCourse[@nLesson]["Steps"].to_i - 1

			if @nLesson < @arrCourse.length - 1
			
				@nLesson = @nLesson + 1
				load_current()

			end			

		end

	end



	def btn_bottom_cl__clicked(button)
		

		@builder["txt_course_cl"].text = @arrCourse[@nLesson]["Course"]
		@builder["txt_lesson_cl"].text = @arrCourse[@nLesson]["Lesson"]


		@nStep = @arrCourse[@nLesson]["Steps"].to_i - 1

		@builder["txt_level_cl"].text = @arrCourse[@nLesson]["step"][@nStep]["Top Level Description"]
		@builder["txt_instruction_cl"].text = @arrCourse[@nLesson]["step"][@nStep]["Instruction"]
		@builder["txt_notes_cl"].text = @arrCourse[@nLesson]["step"][@nStep]["Notes"]
		@builder["img_stepn"].file = @arrCourse[@nLesson]["step"][@nStep]["Image"]
		@builder["imPath_cl"].label = "Image Correspoding to Step(n)" + "\n\n" + @arrCourse[@nLesson]["step"][@nStep]["Image"].split("/")[@arrCourse[@nLesson]["step"][@nStep]["Image"].split("/").size-1]
		@builder["spin_step_ci"].value = @nStep + 1

	end


	def load_current()

		VR::msg "dfs"

		@builder["txt_course_cl"].text = @arrCourse[@nLesson]["Course"]
		@builder["txt_lesson_cl"].text = @arrCourse[@nLesson]["Lesson"]


		@nStep = 3
		@builder["txt_level_cl"].text = @arrCourse[@nLesson]["step"][@nStep]["Top Level Description"]
		@builder["txt_instruction_cl"].text = @arrCourse[@nLesson]["step"][@nStep]["Instruction"]
		@builder["txt_notes_cl"].text = @arrCourse[@nLesson]["step"][@nStep]["Notes"]
		@builder["img_stepn"].file = @arrCourse[@nLesson]["step"][@nStep]["Image"]
		@builder["imPath_cl"].label = "Image Correspoding to Step(n)" + "\n\n" + @arrCourse[@nLesson]["step"][@nStep]["Image"].split("/")[@arrCourse[@nLesson]["step"][@nStep]["Image"].split("/").size-1]

		(0..@arrCourse[@nLesson]["step"].size-1).each do |i|

		  if i  <	 7

		    @builder["txt_cl_" + i.to_s ].text = @arrCourse[@nLesson]["step"][i]["Name"]

		  end
		end


		@builder["spin_step_ci"].value = @nStep + 1



	end


end
