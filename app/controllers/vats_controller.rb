class VatsController < ApplicationController
  def edit
    @vat = Vat.default
    authorize @vat
  end
  def update
    @vat = Vat.default
    authorize @vat
    if @vat.update(vat_params)
      flash[:success] = "VAT Succesfully Updated"
      redirect_to edit_vat_path
    else
      render 'edit'
    end
  end
  private
    def vat_params
      params.require(:vat).permit(:tax_rate)
    end
end
