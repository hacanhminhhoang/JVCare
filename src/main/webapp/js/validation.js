/**
 * Form validation utilities
 */

// Validate email format
function validateEmail(email) {
  const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return re.test(email);
}

// Validate phone number (Vietnam format)
function validatePhone(phone) {
  const re = /^(0|\+84)[0-9]{9}$/;
  return re.test(phone);
}

// Validate required fields
function validateRequired(value) {
  return value !== null && value.trim() !== "";
}

// Add validation to form
function addFormValidation(formId) {
  const form = document.getElementById(formId);
  if (!form) return;

  form.addEventListener("submit", function (e) {
    let isValid = true;
    const inputs = form.querySelectorAll(
      "input[required], select[required], textarea[required]",
    );

    inputs.forEach((input) => {
      if (!validateRequired(input.value)) {
        isValid = false;
        input.classList.add("is-invalid");
        showError(input, "Trường này là bắt buộc");
      } else {
        input.classList.remove("is-invalid");
        hideError(input);
      }

      // Email validation
      if (
        input.type === "email" &&
        input.value &&
        !validateEmail(input.value)
      ) {
        isValid = false;
        input.classList.add("is-invalid");
        showError(input, "Email không hợp lệ");
      }

      // Phone validation
      if (input.type === "tel" && input.value && !validatePhone(input.value)) {
        isValid = false;
        input.classList.add("is-invalid");
        showError(input, "Số điện thoại không hợp lệ");
      }
    });

    if (!isValid) {
      e.preventDefault();
    }
  });
}

function showError(input, message) {
  let errorDiv = input.nextElementSibling;
  if (!errorDiv || !errorDiv.classList.contains("invalid-feedback")) {
    errorDiv = document.createElement("div");
    errorDiv.className = "invalid-feedback";
    input.parentNode.insertBefore(errorDiv, input.nextSibling);
  }
  errorDiv.textContent = message;
}

function hideError(input) {
  const errorDiv = input.nextElementSibling;
  if (errorDiv && errorDiv.classList.contains("invalid-feedback")) {
    errorDiv.remove();
  }
}
