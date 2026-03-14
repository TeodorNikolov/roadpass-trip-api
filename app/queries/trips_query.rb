class TripsQuery

  def initialize(scope = Trip.all, params = {})
    @scope = scope
    @params = params
  end

  def call
    search
    min_rating
    sorted
    @scope
  end

  private

  def search
    return unless @params[:search].present?

    @scope = @scope.where("LOWER(name) LIKE ?", "%#{@params[:search].downcase}%")
  end

  def min_rating
    return unless @params[:min_rating].present?

    @scope = @scope.where("rating >= ?", @params[:min_rating].to_i)
  end

  def sorted
    case @params[:sort]
    when "asc"
      @scope = @scope.order(rating: :asc)
    when "desc"
      @scope = @scope.order(rating: :desc)
    else
      @scope = @scope.order(name: :asc)
    end
  end
end
