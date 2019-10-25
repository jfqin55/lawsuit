package com.zy.bean.bus;
 
import com.rps.util.dao.annotation.GenerateByDb;
import com.rps.util.dao.annotation.Id;
import com.rps.util.dao.annotation.Table;


@Table("t_b_bill_annex")
public class TBBillAnnex {
    @Id
    @GenerateByDb
	private Integer bill_annex_id;
    
    private String bill_id;
    
    private String annex_type;
    
    private String annex_url;
    
    public Integer getBill_annex_id() {
        return bill_annex_id;
    }

    public void setBill_annex_id(Integer bill_annex_id) {
        this.bill_annex_id = bill_annex_id;
    }

    public String getBill_id() {
        return bill_id;
    }

    public void setBill_id(String bill_id) {
        this.bill_id = bill_id;
    }

    public String getAnnex_type() {
        return annex_type;
    }

    public void setAnnex_type(String annex_type) {
        this.annex_type = annex_type;
    }

    public String getAnnex_url() {
        return annex_url;
    }

    public void setAnnex_url(String annex_url) {
        this.annex_url = annex_url;
    }

}
 