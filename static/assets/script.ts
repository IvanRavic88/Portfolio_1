// auto year
const yearEl = document.querySelector<HTMLSpanElement>(".year");
const currentYear = new Date().getFullYear();

if (yearEl) {
  yearEl.textContent = currentYear.toString();
}

// Make mobile navigation work
const btnNavEl = document.querySelector<HTMLButtonElement>(".btn-mobile-nav");
const headerEl = document.querySelector<HTMLElement>(".header");

btnNavEl?.addEventListener("click", () => {
  headerEl?.classList.toggle("nav-open");
});

///////////////////////////////////////////////////////////
// Smooth scrolling animation

const allLinks = document.querySelectorAll<HTMLAnchorElement>(
  ".prevent-default-link"
);

allLinks.forEach((link) => {
  link.addEventListener("click", (e) => {
    e.preventDefault();
    const href = link.getAttribute("href");

    if (href === "#") {
      window.scrollTo({
        top: 0,
        behavior: "smooth",
      });
    } else if (href?.startsWith("#")) {
      const sectionEl = document.querySelector<HTMLElement>(href);
      sectionEl?.scrollIntoView({ behavior: "smooth" });
    }

    if (link.classList.contains("main-nav-link")) {
      headerEl?.classList.toggle("nav-open");
    }
  });
});

///////////////////////////////////////////////////////////
// Fixing flexbox gap property missing in some Safari versions
function checkFlexGap(): void {
  const flex = document.createElement("div");
  flex.style.display = "flex";
  flex.style.flexDirection = "column";
  flex.style.rowGap = "1px";

  flex.appendChild(document.createElement("div"));
  flex.appendChild(document.createElement("div"));

  document.body.appendChild(flex);
  const isSupported = flex.scrollHeight === 1;
  flex.parentNode?.removeChild(flex);

  if (!isSupported) document.body.classList.add("no-flexbox-gap");
}
checkFlexGap();

// COPY MAIL BUTTON

const copyMail = document.querySelector<HTMLButtonElement>(".copy-mail");

copyMail?.addEventListener("click", (event) => {
  navigator.clipboard.writeText("ravic.ivan88@gmail.com");
  const message = document.querySelector<HTMLDivElement>(".copy-message");
  if (message) {
    message.style.display = "flex";
    setTimeout(() => {
      message.style.display = "none";
    }, 2000); // milliseconds until timeout
  }
});

// submiting form to api and lambda function to send email

const ctaForm = document.querySelector<HTMLFormElement>(".cta-form");

const submitButton =
  document.querySelector<HTMLButtonElement>(".message_button");

ctaForm?.addEventListener("submit", async function (e) {
  e.preventDefault();
  // Disable submit button to prevent multiple submissions
  submitButton?.setAttribute("disabled", "true");

  const formData = new FormData(this);
  const formObject: { [key: string]: string } = {};
  formData.forEach((value, key) => {
    formObject[key] = value as string;
  });

  // honeypot field to prevent spam
  const honeypotField_organization =
    this.querySelector<HTMLInputElement>(".organization");
  const honeypotField_fullname =
    this.querySelector<HTMLInputElement>(".fullname");

  if (honeypotField_fullname?.value || honeypotField_organization?.value) {
    return;
  }

  try {
    const response = await fetch("https://api.ivanravic.com", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(formObject),
    });

    const responseData = await response.json();

    if (response.ok) {
      showFormMessage(`${responseData.message}`, "success");
      this.reset();
    } else {
      showFormMessage(
        `Message not sent. Please try again later: ${responseData.message}`,
        "error"
      );
    }
  } catch (error) {
    showFormMessage(
      `Message not sent. Please try again later: ${error}`,
      "error"
    );
  } finally {
    submitButton?.removeAttribute("disabled");
  }
});

function showFormMessage(message: string, type: "success" | "error"): void {
  const ctaForm = document.querySelector<HTMLFormElement>(".cta-form");
  if (ctaForm) {
    const formMessage = ctaForm.querySelector(".flash-message");
    if (formMessage) {
      formMessage.className = `flash-message ${type}`;
      formMessage.textContent = message;

      // Remove the message after 5 seconds
      setTimeout(() => {
        formMessage.textContent = "";
        formMessage.className = "flash-message";
      }, 5000);
    }
  }
}
