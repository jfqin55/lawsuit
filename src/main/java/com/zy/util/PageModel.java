package com.zy.util;

import java.io.Serializable;
import java.util.List;

public class PageModel implements Serializable {
	private static final long serialVersionUID = 1L;

	public List<?> data;

	public Integer total;
	
	public String totalAmount;

	public PageModel(Integer total, List<?> data) {
		super();
		this.total = total;
		this.data = data;
	}

	public List<?> getData() {
		return data;
	}

	public void setData(List<?> data) {
		this.data = data;
	}

	public Integer getTotal() {
		return total;
	}

	public void setTotal(Integer total) {
		this.total = total;
	}

    public String getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(String totalAmount) {
        this.totalAmount = totalAmount;
    }

    public static long getSerialversionuid() {
        return serialVersionUID;
    }

}
