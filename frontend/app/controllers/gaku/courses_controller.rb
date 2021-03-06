module Gaku
  class CoursesController < GakuController

    include StudentChooserController

    helper_method :sort_column, :sort_direction

    respond_to :html, :js

    before_action :set_course,   only: %i( edit show update destroy )
    before_action :set_syllabuses

    def destroy
      @course.destroy
      set_count
      respond_with @course
    end

    def new
      @course = Course.new
      respond_with @course
    end

    def create
      @course = Course.new(course_params)
      @course.use_primary_grading_method_set if @course.save
      set_count
      respond_with @course
    end

    def edit
      set_class_groups
    end

    def show
      # format.json { render json: @course.as_json(include: :students) }
    end

    def update
      @course.update(course_params)
      respond_with @course, location: [:edit, @course]
    end

    def index
      @courses = SemesterConnector.group_by_semester_course
      @courses_without_semester = Course.includes(:syllabus).without_semester
      set_count
      respond_with @courses
    end

    private

    def course_params
      params.require(:course).permit(attributes)
    end

    def attributes
      %i( syllabus_id code )
    end

    def set_course
      @course = Course.includes(syllabus: { exams: :exam_portion_scores }).find(params[:id])
      set_notable
      set_gradable
      set_enrollmentable
      set_semesterable
    end

    def set_notable
      @notable = @course
      @notable_resource = get_resource_name @notable
    end

    def set_gradable
      @gradable = @course
      @gradable_resource = @gradable.class.to_s.demodulize.underscore.dasherize
    end

    def set_enrollmentable
      @enrollmentable = @course
      @enrollmentable_resource = @enrollmentable.class.to_s.demodulize.underscore.dasherize
    end

    def set_semesterable
      @semesterable = @course
      @semesterable_resource = @semesterable.class.to_s.demodulize.underscore.dasherize
    end

    def set_count
      @count = Course.count
    end

    def set_syllabuses
      @syllabuses = Syllabus.all
    end

    def set_class_groups
      @class_groups = ClassGroup.all
    end

    def sort_column
      Student.column_names.include?(params[:sort]) ? params[:sort] : 'surname'
    end

    def sort_direction
      %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
    end

  end
end
