package com.shop.exception;

import com.shop.constant.Constant;

@SuppressWarnings("serial")
public class LoginException extends RuntimeException {

	private int errorCode;

	public LoginException() {
	}

	public LoginException(String message) {
		super(message);
		this.errorCode = Constant.LOGIN_CODE;
	}

	public LoginException(int errorCode, String message) {
		super(message);
		this.errorCode = errorCode;
	}

	public int getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(int errorCode) {
		this.errorCode = errorCode;
	}
	
	
	
	

}
